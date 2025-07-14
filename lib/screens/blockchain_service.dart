import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

class BlockchainService {
  final String _ipfsApiUrl = "http://192.168.107.110:5001";
  final String _rpcUrl = "http://192.168.107.110:7545";
  final String _privateKey =
      "0x4bae1333e93923b77611ef1c50dc87afacbfd83d4c1cbc6cea056fc276c18de9";
  final String _contractAddress = "0xdf875507379310372bc0c1196148f1ab8f5c043a";

  late Web3Client _client;
  late DeployedContract _contract;
  late Credentials _credentials;

  BlockchainService() {
    _client = Web3Client(_rpcUrl, http.Client());
    _credentials = EthPrivateKey.fromHex(_privateKey);
    _initContract();
    print("✅ BlockchainService initialized with IPFS and Ganache");
  }

  void _initContract() {
    const abi = '''[
      {"inputs":[{"internalType":"string","name":"ipfsHash","type":"string"},{"internalType":"uint256","name":"candidateId","type":"uint256"},{"internalType":"string","name":"voterHash","type":"string"}],"name":"recordVote","outputs":[],"stateMutability":"nonpayable","type":"function"},
      {"inputs":[{"internalType":"uint256","name":"candidateId","type":"uint256"}],"name":"getVoteCount","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"}
    ]''';
    _contract = DeployedContract(
      ContractAbi.fromJson(abi, "VoteCounter"),
      EthereumAddress.fromHex(_contractAddress),
    );
  }

  String _hashUsername(String username) {
    return sha256.convert(utf8.encode(username)).toString();
  }

  Future<String> castVote(String username, int candidateId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final voterHash = _hashUsername(username);
      final hasVoted = prefs.getBool(voterHash) ?? false;

      if (hasVoted) {
        throw Exception("User with Aadhaar $username has already voted.");
      }

      final voteTimestamp = DateTime.now().toIso8601String();
      final voteData = {
        "username_hash": voterHash,
        "voting_id": DateTime.now().millisecondsSinceEpoch.toString(),
        "timestamp": voteTimestamp,
        "candidate_id": candidateId,
      };

      final voteJson = jsonEncode(voteData);
      print("🔄 Casting vote: $voteJson");

      // Store timestamp in SharedPreferences first
      await prefs.setBool(voterHash, true);
      await prefs.setString(
        '${voterHash}_timestamp',
        voteTimestamp,
      ); // Fixed syntax
      print("🕒 Stored timestamp: $voteTimestamp for $voterHash");

      final ipfsHash = await _addToIpfs(voteJson);
      print("✅ Vote stored on IPFS with hash: $ipfsHash");

      await _recordVoteOnChain(ipfsHash, candidateId, voterHash);
      print("✅ Vote recorded on Ganache");

      return ipfsHash;
    } catch (e) {
      print("❌ Error in castVote: $e");
      rethrow;
    }
  }

  Future<void> _recordVoteOnChain(
    String ipfsHash,
    int candidateId,
    String voterHash,
  ) async {
    final function = _contract.function('recordVote');
    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: function,
        parameters: [ipfsHash, BigInt.from(candidateId), voterHash],
      ),
      chainId: 1337,
    );
  }

  Future<int> getVoteCount(int candidateId) async {
    final function = _contract.function('getVoteCount');
    final result = await _client.call(
      contract: _contract,
      function: function,
      params: [BigInt.from(candidateId)],
    );
    return (result[0] as BigInt).toInt();
  }

  Future<String> _addToIpfs(String data) async {
    try {
      print("🔗 Sending request to $_ipfsApiUrl/api/v0/add");
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$_ipfsApiUrl/api/v0/add"),
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          utf8.encode(data),
          filename: 'vote.json',
          contentType: MediaType('application', 'json'),
        ),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final result = jsonDecode(responseBody);
        print("📥 IPFS response: $responseBody");
        return result["Hash"];
      } else {
        throw Exception(
          "Failed to add to IPFS: ${response.statusCode} - $responseBody",
        );
      }
    } catch (e) {
      print("❌ IPFS error: $e");
      rethrow;
    }
  }
}
