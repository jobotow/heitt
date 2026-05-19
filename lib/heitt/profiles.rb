module HEITT
  PROFILES = {
    "CRC-16-CCITT" => {
        description: "Cyclic Redundancy Check 16-bit Consultative Commitee for International Telegraph and Telephone",
        notes: ["Used for error detection in communication and storage systems", "Data Integrity and verification", "Memory checks integrity", "Not cryptographic"],
        context: ["checksum", "telecom", "bluetooth"], 
        common_sources: ["V.41", "X.25", "HDLC", "Bluetooth"]
    },
    "CRC-16" => {
        description: "Cyclic Redundancy Check 16-bit — 4 hexadecimal chars, basic checksum",
        notes: ["Error detection in data transmission", "Data storage integrity checks", "Not cryptographic", "Low collision resistance"],
        context: ["checksum", "networking"], 
        prefixes: ["crc-16"],
        common_sources: ["file verification", "network protocols", "embedded systems"]
    },
    "FCS-16" => {
        description: "Frame Check Sequence 6-bit — 4 hexadecimal chars, data link layer",
        notes: ["Not cryptographic"],
        prefixes: ["fcs-16"],
        context: ["checksum", "networking"], 
        common_sources: ["Ethernet frames", "PPP"]
    },
    "Adler-32" => {
        description: "Adler-32 checksum — 8 hex chars, zlib compression",
        common_sources: ["zlib", "PNG files", "RSYNC"], 
        context: ["checksum", "compression"]     
    },
    "CRC-32B" => {
        description: "CRC-32 IEEE 802.3 variant — 8 hex chars, Ethernet standard" ,
        notes: ["Not cryptographic"],
        common_sources: ["Ethernet", "MPEG-2", "PKZIP"], 
        context: ["checksum", "networking"]            
    },
    "FCS-32" => {
        description: "Frame Check Sequence 32-bit — 8 hex chars, advanced networking",
        common_sources: ["advanced networking protocols"], 
        context: ["checksum", "networking"]   
    },
    "GHash-32-3" => {
        description: "G-Hash 32-bit 3-round — 8 hex chars, experimental hash",
        common_sources: ["research", "academic"], 
        context: ["experimental"]
    },
    "GHash-32-5" => {
        description: "G-Hash 32-bit 5-round — 8 hex chars, experimental hash",
        common_sources: ["research", "academic"], 
        context: ["experimental"]
    },
    "FNV-132" => {
        description: "Fowler-Noll-Vo hash 32-bit — 8 hex chars, fast non-crypto hash",
        common_sources: ["DNS", "database indexing", "hash tables"], 
        context: ["checksum", "programming"]
    },
    "Fletcher-32" => {
        description: "Fletcher's checksum 32-bit — 8 hex chars, error detection",
        common_sources: ["OSTA UDF", "ISO/IEC 8473-1"], 
        context: ["checksum", "storage"]
    },
    "Joaat" => {
        description: "Jenkins one-at-a-time hash — 8 hex chars, simple string hash",
        common_sources: ["Perl", "Apache", "various applications"], 
        context: ["programming", "hashing"]
    },
    "ELF-32" => {
        description: "ELF-32 hash for object files — 8 hex chars, Unix/Linux object files",
        context: ["executable", "system"],
        mime_types: ["application/octet-stream"]
    },
    "XOR-32" => {
        description: "Simple XOR-based 32-bit hash — 8 hex chars, basic XOR operation",
        common_sources: ["simple applications", "embedded systems"], 
        context: ["basic", "embedded"]
    },
    "CRC-24" => {
        description: "Cyclic Redundancy Check 24-bits — 6 hexadecimal chars, OpenPGP standard",
        notes: ["Not cryptographic"],
        context: ["checksum"], 
        common_sources: ["OpenPGP", "RFID", "some file formats"]        
    },
    "CRC-32" => {
        description: "Cyclic Redundancy Check 32-bit — 8 hex chars, most common checksum",
        notes: ["Not cryptographic"]
    },
    "DES(Unix)" => {
        description: "DES-based Unix crypt — 13 chars, traditional Unix passwords",
        notes: ["Only 8 char passwords", "weak salt"],
        common_sources: ["/etc/passwd", "old Unix systems"], 
        context: ["unix", "legacy"]   
    },
    "DEScrypt" => {
        description: "DES crypt implementation — 13 chars",
        notes: ["Traditional Unix password hashing"],
        common_sources: ["old Unix/Linux"], 
        context: ["unix", "legacy"]
    },
    "MySQL323" => {
        description: "MySQL 3.23 password hash — 16 chars typical, but can be padded to 32 (hexadecimals)",
        notes: ["Used in old MySQL databases", "Can be broken in seconds", "Susceptible to rainbow tables", "Limited to 8 character passwords", "Deprecated since MySQL 4.1"]
    },
    "DES(Oracle)" => {
        description: "Oracle DES-based hash — 16 hex chars, Oracle specific"
    },
    "Half MD5" => {
        description: "First half of MD5 hash — 16 hex chars, MD5 truncated",
        notes: ["Weaker than full MD5"]
    },
    "FNV-164" => {
        description: "Fowler-Noll-Vo hash 64-bit —  16 hex chars, 64-bit version",
        notes: ["Not cryptographic"]
    },
    "CRC-64" => {
        description: "Cyclic Redundancy Check 64-bit — 16 hex chars, ISO 3309",
        notes: ["Not cryptographic"]
    },
    "CRC-96(ZIP)" => {
        description: "CRC-96 used in some ZIP variants — 24 hex chars, extended CRC",
        notes: ["Not cryptographic", "For some archive formats"]
    },
    "Crypt16" => {
        description: "Extended crypt16 implementation", 
        characteristics: "24 chars, extended DES crypt",
        notes: ["Rarely used", "Used by some Unix variants"]
    },
    "BigCrypt" => {
         description: "Extended DES crypt — 13+ chars, extended length",
        notes: ["Rarely used", "Used in some Unix variants"], 
        common_sources: ["some Unix variants"], 
        context: ["unix", "extended"]
    },
    "MD5" => {
        description: "MD5 cryptographic hash function",
        characteristics: "32 chars, hexadecimal, unsalted",
        notes: ["Used as checksum to verify data or file integrity", "MD5 is cryptographically broken as it is vulnerable to collision attacks"],
        context: ["web", "checksum", "legacy", "password", "hash", "md5"],    
        prefixes: ["md5", "hash", "checksum", "password"],
        file_types: ["shadow", "htpasswd", "logs"],
        mime_types: ["text/plain", "text/x-passwd"],
        common_sources: ["web applications", "file integrity checks", "checksums", "legacy systems"]
    },
    "MD4" => {
        characteristics: "32 chars, legacy Microsoft systems",
        prefixes: ["hash"],
        context: ["hash"],
        common_sources: ["Old Windows systems", "legacy applications"]
    },
    "LM" => {
        description: "Windows LAN Manager hash", 
        characteristics: "16 hex chars, all uppercase, split password",
        notes: ["Mainly found in Windows SAM files(legacy Windows)", "Very weak", "no lowercase", "split passwords"],
        common_sources: ["Windows SAM", "legacy Windows systems"], 
        context: ["windows", "SAM"]
    },
    "NTLM" => {
        description: "Windows NTLM authentication hash",
        characteristics: "32 chars, Windows authentication, based on MD4",
        notes: ["Hashcat Mode: 5600 (NetNTLMv2) - if network captured", "Hashcat Mode: 5500 (NetNTLMv1/NetNTLMv1+ESS) - legacy versions", "John Format: netntlm (for network hashes)", "John Format: netntlmv2 (v2 hashes)"],
        context: ["windows", "SAM", "LSASS", "nt", "ntlm"],
        prefixes: ["nt"],
        file_types: ["ntds", "logs"],
        mime_types: ["text/plain", "application/octet-stream"],
        common_sources: ["Windows SAM", "Active Directory", "LSASS memory"]
    },
    "SHA-1" => {
        description: "SHA-1 cryptographic hash function", 
        characteristics: "40 chars, hexadecimal, unsalted",
        notes: ["Used for file verification", "found in git commits and legacy certificates"],
        prefixes: ["sha1", "hash"],
        context: ["sha1", "hash"]
    },
    "RIPEMD-160" => {
        characteristics: "40 chars, Bitcoin addresses, digital signatures",
        notes: ["Rarely used for passwords"]
    },
    "Android PIN" => {
        description: "Android PIN/Password hash", 
        characteristics: "40 chars hash + 16 chars salt, SHA1 + MD5",
        notes: ["found in android gesture.key files"]
    },
    "SHA-512 Crypt" => {
        characteristics: "$6$ prefix, includes salt, 96-106 chars", 
        notes: ["Industry standard for modern Linux systems"]
    },
  }
end
