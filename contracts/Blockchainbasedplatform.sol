## contracts details 0xf241d2c7846b8ccace816744b56803cf4962aa24
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Blockchain-Based Skill Certification Platform
/// @notice Enables educators and organizations to issue tamper-proof skill certificates on blockchain.
contract Project {
    struct Certificate {
        string skillName;
        address certifiedTo;
        address issuedBy;
        uint256 issuedAt;
    }

    mapping(uint256 => Certificate) public certificates;
    uint256 public certCount;

    event CertificateIssued(uint256 certId, string skillName, address indexed certifiedTo, address issuedBy, uint256 issuedAt);

    /// @notice Issue a certificate for a skill to a recipient
    /// @param skillName Name of skill certified
    /// @param to Address of recipient
    function issueCertificate(string calldata skillName, address to) external {
        certCount++;
        certificates[certCount] = Certificate(skillName, to, msg.sender, block.timestamp);
        emit CertificateIssued(certCount, skillName, to, msg.sender, block.timestamp);
    }

    /// @notice Fetch certificate details by its ID
    /// @param certId ID of the certificate
    function getCertificate(uint256 certId) external view returns (string memory, address, address, uint256) {
        Certificate memory cert = certificates[certId];
        return (cert.skillName, cert.certifiedTo, cert.issuedBy, cert.issuedAt);
    }

    /// @notice Verify whether a user holds a specific skill certificate
    /// @param skillName Skill to verify
    /// @param user User address
    function verifySkill(string calldata skillName, address user) external view returns (bool) {
        for (uint256 i = 1; i <= certCount; i++) {
            Certificate memory cert = certificates[i];
            if (cert.certifiedTo == user && keccak256(abi.encodePacked(cert.skillName)) == keccak256(abi.encodePacked(skillName))) {
                return true;
            }
        }
        return false;
    }
}
