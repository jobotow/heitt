module HEITT
  PROFILES = {
    # Checksums (non-cryptographic) 
    "CRC-16-CCITT" => {
      description: "Cyclic Redundancy Check 16-bit Consultative Commitee for International Telegraph and Telephone",
      notes: ["Used for error detection in communication and storage systems", "Data Integrity and verification", "Memory checks integrity", "Not cryptographic"],
      context: ["checksum", "telecom", "bluetooth"],
      common_sources: ["V.41", "X.25", "HDLC", "Bluetooth"]
    },
    "CRC-16" => {
      description: "Cyclic Redundancy Check 16-bit - 4 hex chars , basic checksum",
      notes: ["Error detection in data transmission", "Data storage integrity checks", "Not cryptographic", "Low collision resistance"],
      context: ["checksum", "networking"],
      prefixes: ["crc-16", "crc16"],
      common_sources: ["file verification", "network protocols", "embedded systems"]
    },
    "FCS-16" => {
      description: "Frame Check Sequence 16-bit - 4 hex chars, data link layer",
      notes: ["Not cryptographic"],
      context: ["checksum", "networking"],
      prefixes: ["fcs-16", "fcs16"],
      common_sources: ["Ethernet frames", "PPP"]
    },
    "Adler-32" => {
      description: "Adler-32 checksum - 8 hex chars, zlib compression",
      notes: ["Not cryptographic"],
      context: ["checksum", "compression", "zlib"],
      prefixes: ["adler32", "adler-32"],
      common_sources: ["zlib", "PNG files", "rsync"]
    },
    "CRC-32B" => {
      description: "CRC-32 IEEE 802.3 variant - 8 hex chars, Ethernet standard",
      notes: ["Not cryptographic"],
      context: ["checksum", "networking"],
      common_sources: ["Ethernet", "MPEG-2", "PKZIP"]
    },
    "FCS-32" => {
      description: "Frame Check Sequence 32-bit - 8 hex chars, advanced networking",
      notes: ["Not cryptographic"],
      context: ["checksum", "networking"],
      prefixes: ["fcs-32", "fcs32"],
      common_sources: ["networking protocols"]
    },
    "GHash-32-3" => {
      description: "G-Hash 32-bit, 3 rounds - 8 hex chars, experimental",
      context: ["experimental"],
      common_sources: ["research", "academic"]
    },
    "GHash-32-5" => {
      description: "G-Hash 32-bit, 5 rounds - 8 hex chars, experimental",
      context: ["experimental"],
      common_sources: ["research", "academic"]
    },
    "FNV-132" => {
      description: "Fowler-Noll-Vo hash 32-bit - 8 hex chars, fast non-cryptographic hash",
      notes: ["Not cryptographic"],
      context: ["fnv", "programming"],
      prefixes: ["fnv", "fnv1"],
      common_sources: ["DNS", "database indexing", "hash tables"]
    },
    "Fletcher-32" => {
      description: "Fletcher's checksum 32-bit - 8 hex chars, error detection",
      notes: ["Not cryptographic"],
      context: ["checksum", "storage", "fletcher"],
      common_sources: ["OSTA UDF", "ISO/IEC 8473-1"]
    },
    "Joaat" => {
      description: "Jenkins one-at-a-time hash - 8 hex chars, simple string hash",
      notes: ["Not cryptographic"],
      context: ["joaat", "jenkins", "programming"],
      common_sources: ["Perl", "Apache", "various applications"]
    },
    "ELF-32" => {
      description: "ELF-32 hash for object files - 8 hex chars, Unix/Linux object files",
      context: ["elf", "executable"],
      common_sources: ["ELF object files"]
    },
    "XOR-32" => {
      description: "Simple XOR-based 32-bit hash - 8 hex chars",
      notes: ["Not cryptographic"],
      context: ["xor", "embedded"],
      common_sources: ["simple applications", "embedded systems"]
    },
    "CRC-24" => {
      description: "Cyclic Redundancy Check 24-bit - 6 hex chars, OpenPGP standard",
      notes: ["Not cryptographic"],
      context: ["checksum", "openpgp", "pgp"],
      common_sources: ["OpenPGP", "RFID", "some file formats"]
    },
    "CRC-32" => {
      description: "Cyclic Redundancy Check 32-bit - 8 hex chars, most common checksum",
      notes: ["Not cryptographic"],
      context: ["checksum", "crc32"],
      prefixes: ["crc32", "crc-32"],
      common_sources: ["ZIP", "gzip", "PNG"]
    },
    "CRC-64" => {
      description: "Cyclic Redundancy Check 64-bit - 16 hex chars, ISO 3309",
      notes: ["Not cryptographic"],
      context: ["checksum", "crc64"],
      prefixes: ["crc64", "crc-64"]
    },
    "CRC-96(ZIP)" => {
      description: "CRC-96 used in some ZIP variants - 24 hex chars",
      notes: ["Not cryptographic", "For some archive formats"],
      context: ["checksum", "zip"]
    },
    "FNV-164" => {
      description: "Fowler-Noll-Vo hash 64-bit - 16 hex chars",
      notes: ["Not cryptographic"],
      context: ["fnv", "programming"],
      prefixes: ["fnv", "fnv1"]
    },

    # Legacy password hashes
    "DES(Unix)" => {
      description: "DES-based Unix crypt - 13 chars, traditional Unix passwords",
      notes: ["Only the first 8 characters of the password are used", "Weak salt"],
      context: ["unix", "passwd", "legacy"],
      common_sources: ["/etc/passwd", "old Unix systems"]
    },
    "DEScrypt" => {
      description: "DES crypt implementation - 13 chars",
      notes: ["Traditional Unix password hashing"],
      context: ["unix", "passwd", "legacy"],
      common_sources: ["old Unix/Linux"]
    },
    "BigCrypt" => {
      description: "Extended DES crypt - 13+ chars, extended length",
      notes: ["Rarely used", "Used in some Unix variants"],
      context: ["unix", "legacy"],
      common_sources: ["some Unix variants"]
    },
    "Crypt16" => {
      description: "Extended crypt16 implementation - 24 chars, extended DES crypt",
      notes: ["Rarely used", "Used by some Unix variants"],
      context: ["unix", "legacy"]
    },
    "MySQL323" => {
      description: "MySQL 3.23 password hash - 16 hex chars (can be padded to 32)",
      notes: ["Used in old MySQL databases", "Can be broken in seconds", "Susceptible to rainbow tables", "Limited to 8 character passwords", "Deprecated since MySQL 4.1"],
      context: ["mysql"],
      prefixes: ["mysql", "mysql323"],
      common_sources: ["old MySQL user tables"]
    },
    "DES(Oracle)" => {
      description: "Oracle DES-based hash - 16 hex chars",
      context: ["oracle"],
      common_sources: ["Oracle databases"]
    },
    "LM" => {
      description: "Windows LAN Manager hash - 16 hex chars (often shown as two halves), no lowercase, split password",
      notes: ["Mainly found in legacy Windows SAM files", "Very weak"],
      context: ["windows", "sam", "lm"],
      prefixes: ["lm", "lmhash"],
      common_sources: ["Windows SAM", "legacy Windows systems"]
    },
    "NTLM" => {
      description: "Windows NTLM authentication hash (MD4 of the UTF-16LE password) - 32 hex chars, unsalted",
      notes: [
        "Network-captured NetNTLMv2 - Hashcat mode: 5600, John format: netntlmv2",
        "Network-captured NetNTLMv1 / NetNTLMv1+ESS (legacy) - Hashcat mode: 5500, John format: netntlm"
      ],
      context: ["windows", "sam", "lsass", "ntds", "nt", "ntlm"],
      prefixes: ["nt", "ntlm", "nthash"],
      common_sources: ["Windows SAM", "Active Directory (NTDS)", "LSASS memory"]
    },

    # Cryptographic hashes
    "Half MD5" => {
      description: "First half of an MD5 hash - 16 hex chars",
      notes: ["Weaker than full MD5"],
      context: ["md5"]
    },
    "MD4" => {
      description: "MD4 cryptographic hash function - 32 hex chars, unsalted",
      notes: ["Legacy, broken", "Basis of the NTLM hash"],
      context: ["md4"],
      prefixes: ["md4"],
      common_sources: ["old Windows systems", "legacy applications"]
    },
    "MD5" => {
      description: "MD5 cryptographic hash function - 32 hex chars, unsalted",
      notes: ["Used as a checksum to verify data or file integrity", "Broken: vulnerable to collision attacks"],
      context: ["md5", "checksum", "legacy"],
      prefixes: ["md5", "md5sum"],
      common_sources: ["web applications", "file integrity checks", "checksums", "legacy systems"]
    },
    "SHA-1" => {
      description: "SHA-1 cryptographic hash function - 40 hex chars, unsalted",
      notes: ["Used for file verification", "Found in git commits and legacy certificates"],
      context: ["sha1", "sha-1", "git"],
      prefixes: ["sha1", "sha-1", "sha1sum"],
      common_sources: ["git", "legacy certificates"]
    },
    "RIPEMD-160" => {
      description: "RIPEMD-160 hash function - 40 hex chars",
      notes: ["Rarely used for passwords", "Used in Bitcoin addresses"],
      context: ["ripemd", "ripemd160", "bitcoin"],
      prefixes: ["ripemd160", "ripemd-160"]
    },
    "Android PIN" => {
      description: "Android PIN/password hash - 40 hex chars hash + 16 chars salt (SHA-1 + MD5)",
      notes: ["Found in Android gesture.key files"],
      context: ["android"],
      common_sources: ["Android lock-screen files"]
    },
    "SHA-512 Crypt" => {
      description: "SHA-512 based Unix crypt - $6$ prefix, includes salt, 96-106 chars",
      notes: ["Standard for modern Linux systems"],
      context: ["shadow", "unix", "linux"],
      common_sources: ["/etc/shadow"]
    },

    # SHA-2 family
    "SHA-224" => {
      description: "SHA-224 cryptographic hash function (truncated SHA-2)",
      notes: ["Rarely used for passwords"],
      context: ["sha224", "sha-224"]
    },
    "SHA-256" => {
      description: "SHA-256 cryptographic hash function (SHA-2 family)",
      notes: ["Fast and usually unsalted, so weak for password storage on its own", "Common in file checksums, certificates and blockchains"],
      context: ["sha256", "sha-256"],
      common_sources: ["file checksums", "TLS certificates", "web applications"]
    },
    "SHA-384" => {
      description: "SHA-384 cryptographic hash function (SHA-2 family)",
      notes: ["Rarely used for passwords"],
      context: ["sha384", "sha-384"],
      common_sources: ["TLS certificates"]
    },
    "SHA-512" => {
      description: "SHA-512 cryptographic hash function (SHA-2 family)",
      notes: ["Fast and usually unsalted, so weak for password storage on its own"],
      context: ["sha512", "sha-512"],
      common_sources: ["file checksums", "web applications"]
    },

    # Unix crypt family
    "MD5 Crypt" => {
      description: "MD5-based Unix crypt - $1$ prefix, includes salt",
      notes: ["Legacy, replaced by SHA-256/SHA-512 crypt on modern Linux", "Still found on old systems and network devices"],
      context: ["shadow", "unix", "linux"],
      common_sources: ["/etc/shadow", "old Unix/Linux systems", "network devices"]
    },
    "SHA-256 Crypt" => {
      description: "SHA-256 based Unix crypt - $5$ prefix, includes salt",
      notes: ["Salted, with many rounds by default"],
      context: ["shadow", "unix", "linux"],
      common_sources: ["/etc/shadow"]
    },
    "Apache MD5" => {
      description: "Apache MD5 (apr1) - $apr1$ prefix, includes salt",
      notes: ["Used in Apache .htpasswd files", "Weak by modern standards"],
      context: ["apache", "htpasswd"],
      common_sources: [".htpasswd files"]
    },
    "bcrypt" => {
      description: "bcrypt adaptive password hash - $2a$/$2b$/$2y$ prefix, includes salt and cost factor",
      notes: ["Deliberately slow, so strong against brute force", "Cracking is very slow even on a GPU"],
      context: ["bcrypt", "blowfish"],
      common_sources: ["web applications", "BSD systems"]
    },

    # Windows / Active Directory
    "NetNTLMv2" => {
      description: "NetNTLMv2 challenge/response hash",
      notes: ["Network authentication hash, not the stored NTLM hash", "Captured on the wire, e.g. with Responder"],
      context: ["netntlmv2", "ntlmv2", "responder", "smb"],
      common_sources: ["network captures", "SMB/HTTP authentication"]
    },
    "NetNTLMv1-VANILLA / NetNTLMv1+ESS" => {
      description: "NetNTLMv1 challenge/response hash (legacy)",
      notes: ["Network authentication hash, not the stored NTLM hash", "Legacy and much weaker than NetNTLMv2"],
      context: ["netntlmv1", "ntlmv1", "responder", "smb"],
      common_sources: ["network captures", "SMB/HTTP authentication"]
    },
    "Domain Cached Credentials" => {
      description: "Domain Cached Credentials (MS Cache v1, mscash)",
      notes: ["Cached domain logon hash stored locally on Windows machines", "Cannot be used for pass-the-hash, it has to be cracked"],
      context: ["mscash", "mscache", "dcc", "windows"],
      common_sources: ["Windows registry (SECURITY hive)"]
    },
    "Domain Cached Credentials 2" => {
      description: "Domain Cached Credentials 2 (MS Cache v2, mscash2)",
      notes: ["Newer and slower to crack than v1", "Stored locally on Windows machines"],
      context: ["mscash2", "mscache2", "dcc2", "windows"],
      common_sources: ["Windows registry (SECURITY hive)"]
    },
    "SAM(LM_Hash:NT_Hash)" => {
      description: "Windows SAM entry in LM:NT format",
      notes: ["Holds both the LM and NTLM hash, separated by a colon", "An LM part of aad3b435b51404eeaad3b435b51404ee means LM is disabled"],
      context: ["sam", "windows", "pwdump", "secretsdump"],
      common_sources: ["pwdump / secretsdump output", "Windows SAM"]
    },
    "Kerberos 5 AS-REQ Pre-Auth" => {
      description: "Kerberos 5 AS-REQ pre-authentication hash",
      notes: ["Captured from Kerberos network traffic", "Cracked offline to recover the account password"],
      context: ["kerberos", "krb5"],
      common_sources: ["network captures", "Active Directory"]
    },

    # Databases and applications
    "MySQL4.1" => {
      description: "MySQL 4.1 password hash - double SHA-1 with a leading *",
      notes: ["Unsalted", "Replaced the older MySQL323 format"],
      context: ["mysql"],
      common_sources: ["MySQL user tables"]
    },
    "MySQL5.x" => {
      description: "MySQL 5.x password hash - double SHA-1 with a leading *",
      notes: ["Unsalted", "Same format as MySQL 4.1"],
      context: ["mysql"],
      common_sources: ["MySQL user tables"]
    },
    "LinkedIn" => {
      description: "LinkedIn breach format - unsalted SHA-1 variant",
      notes: ["Unsalted, so fast to crack"],
      context: ["linkedin"],
      common_sources: ["LinkedIn breach dump"]
    },
    "Cisco Type 7" => {
      description: "Cisco Type 7 reversible password encoding",
      notes: ["Reversible obfuscation, not a real hash", "Can be decoded instantly, no cracking needed"],
      context: ["cisco", "ios"],
      common_sources: ["Cisco IOS configuration files"]
    }
  }.freeze
end
