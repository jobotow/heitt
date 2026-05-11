module HEITT
  DATABASE = [
    {
        _credit: "Adapted from hashid prototypes.json by psypanda",
        _source: "https://github.com/psypanda/hashID",
        _license: "GPL-3.0"
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{4}\b', Regexp::IGNORECASE),
        modes: [
            {
                name:"CRC-16",
                john: nil,
                hashcat: nil,
                extended: false,
                description: "Cyclic Redundancy Check 16-bit — 4 hexadecimal chars, basic checksum",
                notes: ["Error detection in data transmission", "Data storage integrity checks", "Not cryptographic", "Low collision resistance"],
                context: ["checksum", "networking"], 
                prefixes: ["crc-16"],
                common_sources: ["file verification", "network protocols", "embedded systems"]

            },
            {
                name:"CRC-16-CCITT",
                john: nil,
                hashcat: nil,
                extended: false,
                description: "Cyclic Redundancy Check 16-bit Consultative Commitee for International Telegraph and Telephone",
                notes: ["Used for error detection in communication and storage systems", "Data Integrity and verification", "Memory checks integrity", "Not cryptographic"],
                context: ["checksum", "telecom", "bluetooth"], 
                common_sources: ["V.41", "X.25", "HDLC", "Bluetooth"]
            },
            {
                name:"FCS-16",
                john: nil,
                hashcat: nil,
                extended: false,
                description: "Frame Check Sequence 6-bit — 4 hexadecimal chars, data link layer",
                notes: ["Not cryptographic"],
                prefixes: ["fcs-16"],
                context: ["checksum", "networking"], 
                common_sources: ["Ethernet frames", "PPP"]
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{8}\b', Regexp::IGNORECASE),
        modes: [
            {
                name:"Adler-32",
                john: nil,
                hashcat: nil,
                extended: false,
                description: "Adler-32 checksum — 8 hex chars, zlib compression",
                common_sources: ["zlib", "PNG files", "RSYNC"], 
                context: ["checksum", "compression"]     
            },
            {
                name:"CRC-32B",
                john: nil,
                hashcat: nil,
                extended: false,
                description: "CRC-32 IEEE 802.3 variant — 8 hex chars, Ethernet standard" ,
                notes: ["Not cryptographic"],
                common_sources: ["Ethernet", "MPEG-2", "PKZIP"], 
                context: ["checksum", "networking"]            
            },
            {
                name:"FCS-32",
                john: nil,
                hashcat: nil,
                extended: false,
                description: "Frame Check Sequence 32-bit — 8 hex chars, advanced networking",
                common_sources: ["advanced networking protocols"], 
                context: ["checksum", "networking"]       
            },
            {
                name:"GHash-32-3",
                john: nil,
                hashcat: nil,
                extended: false,
                description: "G-Hash 32-bit 3-round — 8 hex chars, experimental hash",
                  common_sources: ["research", "academic"], 
                context: ["experimental"]
            }, 
            {
                name:"GHash-32-5",
                john: nil,
                hashcat: nil,
                extended: false,
                description: "G-Hash 32-bit 5-round — 8 hex chars, experimental hash",
                common_sources: ["research", "academic"], 
                context: ["experimental"]
            },
            {
                name:"FNV-132",
                john: nil,
                hashcat: nil,
                extended: false,
                description: "Fowler-Noll-Vo hash 32-bit — 8 hex chars, fast non-crypto hash",
                common_sources: ["DNS", "database indexing", "hash tables"], 
                context: ["checksum", "programming"]
            },
            {
                name:"Fletcher-32",
                john: nil,
                hashcat: nil,
                extended: false,
                description: "Fletcher's checksum 32-bit — 8 hex chars, error detection",
                common_sources: ["OSTA UDF", "ISO/IEC 8473-1"], 
                context: ["checksum", "storage"]
            },
            {
                name:"Joaat",
                john: nil,
                hashcat: nil,
                extended: false,
                description: "Jenkins one-at-a-time hash — 8 hex chars, simple string hash",
                common_sources: ["Perl", "Apache", "various applications"], 
                context: ["programming", "hashing"]
            },
            {
                name:"ELF-32",
                john: nil,
                hashcat: nil,
                extended: false,
                description: "ELF-32 hash for object files — 8 hex chars, Unix/Linux object files",
                context: ["executable", "system"],
                "mime_types": ["application/octet-stream"]
                
            },
            {
                name:"XOR-32",
                john: nil,
                hashcat: nil,
                extended: false,
                description: "Simple XOR-based 32-bit hash — 8 hex chars, basic XOR operation",
                common_sources: ["simple applications", "embedded systems"], 
                context: ["basic", "embedded"]
                
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{6}\b', Regexp::IGNORECASE),
        modes: [
            {
                name:"CRC-24",
                john: nil,
                hashcat: nil,
                extended: false,
                description: "Cyclic Redundancy Check 24-bits — 6 hexadecimal chars, OpenPGP standard",
                notes: ["Not cryptographic"],
                context: ["checksum"], 
                common_sources: ["OpenPGP", "RFID", "some file formats"]           
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b(\$crc32\$[a-f0-9]{8}.)?[a-f0-9]{8}\b', Regexp::IGNORECASE),
        modes: [
            {
                name:"CRC-32",
                john: "crc32",
                hashcat: nil,
                extended: false,
                description: "Cyclic Redundancy Check 32-bit — 8 hex chars, most common checksum",
                notes: ["Not cryptographic"]
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\\+[a-z0-9\\/.]{12}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "bfegg",
                hashcat: nil,
                extended: false,
                name:"Eggdrop IRC Bot"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-z0-9\\/.]{13}\b', Regexp::IGNORECASE),
        modes: [
            {
                name:"DES(Unix)",
                john: "descrypt",
                hashcat: 1500,
                extended: false,
                description: "DES-based Unix crypt — 13 chars, traditional Unix passwords",
                notes: ["Only 8 char passwords", "weak salt"],
                common_sources: ["/etc/passwd", "old Unix systems"], 
                context: ["unix", "legacy"]   
            },
            {
                name:"Traditional DES",
                john: "descrypt",
                hashcat: 1500,
                extended: false
                
            },
            {
                name:"DEScrypt",
                john: "descrypt",
                hashcat: 1500,
                extended: false,
                description: "DES crypt implementation — 13 chars",
                notes: ["Traditional Unix password hashing"],
                common_sources: ["old Unix/Linux"], 
                context: ["unix", "legacy"]
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{16}\b', Regexp::IGNORECASE),
        modes: [
            {
                name:"MySQL323",
                john: "mysql",
                hashcat: 200,
                extended: false,
                description: "MySQL 3.23 password hash — 16 chars typical, but can be padded to 32 (hexadecimals)",
                notes: ["Used in old MySQL databases", "Can be broken in seconds", "Susceptible to rainbow tables", "Limited to 8 character passwords", "Deprecated since MySQL 4.1"]
            },
            {
                name:"DES(Oracle)",
                john: nil,
                hashcat: 3100,
                extended: false,
                description: "Oracle DES-based hash — 16 hex chars, Oracle specific"
            },
            {
                name:"Half MD5",
                john: nil,
                hashcat: 5100,
                extended: false,
                description: "First half of MD5 hash — 16 hex chars, MD5 truncated",
                notes: ["Weaker than full MD5"]
            },
            {
                name:"Oracle 7-10g",
                john: nil,
                hashcat: 3100,
                extended: false
            },
            {
                name:"FNV-164",
                john: nil,
                hashcat: nil,
                extended: false,
                description: "Fowler-Noll-Vo hash 64-bit —  16 hex chars, 64-bit version",
                notes: ["Not cryptographic"]
            },
            {
                name:"CRC-64",
                john: nil,
                hashcat: nil,
                extended: false,
                description: "Cyclic Redundancy Check 64-bit — 16 hex chars, ISO 3309",
                notes: ["Not cryptographic"]
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-z0-9\\/.]{16}\b', Regexp::IGNORECASE),
        modes: [
            {
                name:"Cisco-PIX(MD5)",
                john: "pix-md5",
                hashcat: 2400,
                extended: false,
                description: "Cisco PIX MD5 hash"            
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\\([a-z0-9\\/+]{20}\\)\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "dominosec",
                hashcat: 8700,
                extended: false,
                name:"Lotus Notes/Domino 6"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b_[a-z0-9\\/.]{19}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "bsdicrypt",
                hashcat: nil,
                extended: false,
                name:"BSDi Crypt"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{24}\b', Regexp::IGNORECASE),
        modes: [
            {
                name:"CRC-96(ZIP)",
                john: nil,
                hashcat: nil,
                extended: false,
                description: "CRC-96 used in some ZIP variants — 24 hex chars, extended CRC",
                notes: ["Not cryptographic", "For some archive formats"]
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-z0-9\\/.]{24}\b', Regexp::IGNORECASE),
        modes: [
            {
                name:"Crypt16",
                john: nil,
                hashcat: nil,
                extended: false,
                description: "Extended crypt16 implementation", 
                characteristics: "24 chars, extended DES crypt",
                notes: ["Rarely used", "Used by some Unix variants"]
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b(\$md2\$)?[a-f0-9]{32}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "md2",
                hashcat: nil,
                extended: false,
                name:"MD2"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{32}(:.+)?\b', Regexp::IGNORECASE),
        modes: [
            {
                name:"MD5",
                john: "raw-md5",
                hashcat: 0,
                extended: false,
                description: "MD5 cryptographic hash function",
                characteristics: "32 chars, hexadecimal, unsalted",
                notes: ["Used as checksum to verify data or file integrity", "MD5 is cryptographically broken as it is vulnerable to collision attacks"],
                context: ["web", "checksum", "legacy", "password", "hash", "md5"],    
                prefixes: ["md5", "hash", "checksum", "password"],
                file_types: ["shadow", "htpasswd", "logs"],
                mime_types: ["text/plain", "text/x-passwd"],
                common_sources: ["web applications", "file integrity checks", "checksums", "legacy systems"]

            },
            {
                name:"MD4",
                john: "raw-md4",
                hashcat: 900,
                extended: false,
                characteristics: "32 chars, legacy Microsoft systems",
                prefixes: ["hash"],
                context: ["hash"],
                common_sources: ["Old Windows systems", "legacy applications"]
            },
            {
                name:"Double MD5",
                john: nil,
                hashcat: 2600,
                extended: false
            },
            {
                name:"LM",
                john: "lm",
                hashcat: 3000,
                extended: false,
                description: "Windows LAN Manager hash", 
                characteristics: "16 hex chars, all uppercase, split password",
                notes: ["Mainly found in Windows SAM files(legacy Windows)", "Very weak", "no lowercase", "split passwords"],
                common_sources: ["Windows SAM", "legacy Windows systems"], 
                context: ["windows", "SAM"]
            },
            {
                name:"RIPEMD-128",
                john: "ripemd-128",
                hashcat: nil,
                extended: false
            },
            {
                name:"Haval-128",
                john: "haval-128-4",
                hashcat: nil,
                extended: false
            },
            {
                 name:"Tiger-128",
                john: nil,
                hashcat: nil,
                extended: false
            },
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Skein-256(128)"
            },
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Skein-512(128)"
            },
            {
                john: "lotus5",
                hashcat: 8600,
                extended: false,
                name:"Lotus Notes/Domino 5"
            },
            {
                john: nil,
                hashcat: 23,
                extended: false,
                name:"Skype"
            },
            {
                john: nil,
                hashcat: nil,
                extended: true,
                name:"ZipMonster"
            },
            {
                john: nil,
                hashcat: 11000,
                extended: true,
                name:"PrestaShop"
            },
            {
                john: nil,
                hashcat: 3500,
                extended: true,
                name:"md5(md5(md5($pass)))"
            },
            {
                john: nil,
                hashcat: 4300,
                extended: true,
                name:"md5(strtoupper(md5($pass)))"
            },
            {
                john: nil,
                hashcat: 4400,
                extended: true,
                name:"md5(sha1($pass))"
            },
            {
                john: nil,
                hashcat: 10,
                extended: true,
                name:"md5($pass.$salt)"
            },
            {
                john: nil,
                hashcat: 20,
                extended: true,
                name:"md5($salt.$pass)"
            },
            {
                john: nil,
                hashcat: 30,
                extended: true,
                name:"md5(unicode($pass).$salt)"
            },
            {
                john: nil,
                hashcat: 40,
                extended: true,
                name:"md5($salt.unicode($pass))"
            },
            {
                john: "hmac-md5",
                hashcat: 50,
                extended: true,
                name:"HMAC-MD5 (key = $pass)"
            },
            {
                john: "hmac-md5",
                hashcat: 60,
                extended: true,
                name:"HMAC-MD5 (key = $salt)"
            },
            {
                john: nil,
                hashcat: 3610,
                extended: true,
                name:"md5(md5($salt).$pass)"
            },
            {
                john: nil,
                hashcat: 3710,
                extended: true,
                name:"md5($salt.md5($pass))"
            },
            {
                john: nil,
                hashcat: 3720,
                extended: true,
                name:"md5($pass.md5($salt))"
            },
            {
                john: nil,
                hashcat: 3810,
                extended: true,
                name:"md5($salt.$pass.$salt)"
            },
            {
                john: nil,
                hashcat: 3910,
                extended: true,
                name:"md5(md5($pass).md5($salt))"
            },
            {
                john: nil,
                hashcat: 4010,
                extended: true,
                name:"md5($salt.md5($salt.$pass))"
            },
            {
                john: nil,
                hashcat: 4110,
                extended: true,
                name:"md5($salt.md5($pass.$salt))"
            },
            {
                john: nil,
                hashcat: 4210,
                extended: true,
                name:"md5($username.0.$pass)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b(\$snefru\$)?[a-f0-9]{32}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "snefru-128",
                hashcat: nil,
                extended: false,
                name:"Snefru-128"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b(\$NT\$)?[a-f0-9]{32}\b', Regexp::IGNORECASE),
        modes: [
            {
                name:"NTLM",
                john: "nt",
                hashcat: 1000,
                extended: false,
                description: "Windows NTLM authentication hash",
                characteristics: "32 chars, Windows authentication, based on MD4",
                notes: ["Hashcat Mode: 5600 (NetNTLMv2) - if network captured", "Hashcat Mode: 5500 (NetNTLMv1/NetNTLMv1+ESS) - legacy versions", "John Format: netntlm (for network hashes)", "John Format: netntlmv2 (v2 hashes)"],
                context: ["windows", "SAM", "LSASS", "nt", "ntlm"],
                prefixes: ["nt"],
                file_types: ["ntds", "logs"],
                mime_types: ["text/plain", "application/octet-stream"],
                common_sources: ["Windows SAM", "Active Directory", "LSASS memory"]
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b([^\\\\\\/:*?\"<>|]{1,20}:)?[a-f0-9]{32}(:[^\\\\\\/:*?\"<>|]{1,20})?\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "mscach",
                hashcat: 1100,
                extended: false,
                name:"Domain Cached Credentials"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b([^\\\\\\/:*?\"<>|]{1,20}:)?(\$DCC2\$10240#[^\\\\\\/:*?\"<>|]{1,20}#)?[a-f0-9]{32}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "mscach2",
                hashcat: 2100,
                extended: false,
                name:"Domain Cached Credentials 2"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b{SHA}[a-z0-9\\/+]{27}=\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "nsldap",
                hashcat: 101,
                extended: false,
                name:"SHA-1(Base64)"
            },
            {
                john: "nsldap",
                hashcat: 101,
                extended: false,
                name:"Netscape LDAP SHA"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$1\$[a-z0-9\\/.]{0,8}\$[a-z0-9\\/.]{22}(:.*)?\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "md5crypt",
                hashcat: 500,
                extended: false,
                name:"MD5 Crypt"
            },
            {
                john: "md5crypt",
                hashcat: 500,
                extended: false,
                name:"Cisco-IOS(MD5)"
            },
            {
                john: "md5crypt",
                hashcat: 500,
                extended: false,
                name:"FreeBSD MD5"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b0x[a-f0-9]{32}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Lineage II C4"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$H\$[a-z0-9\\/.]{31}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "phpass",
                hashcat: 400,
                extended: false,
                name:"phpBB v3.x"
            },
            {
                john: "phpass",
                hashcat: 400,
                extended: false,
                name:"Wordpress v2.6.0/2.6.1"
            },
            {
                john: "phpass",
                hashcat: 400,
                extended: false,
                name:"PHPass' Portable Hash"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$P\$[a-z0-9\\/.]{31}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "phpass",
                hashcat: 400,
                extended: false,
                name:"Wordpress \u2265 v2.6.2"
            },
            {
                john: "phpass",
                hashcat: 400,
                extended: false,
                name:"Joomla \u2265 v2.5.18"
            },
            {
                john: "phpass",
                hashcat: 400,
                extended: false,
                name:"PHPass' Portable Hash"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{32}:[a-z0-9]{2}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: 21,
                extended: false,
                name:"osCommerce"
            },
            {
                john: nil,
                hashcat: 21,
                extended: false,
                name:"xt:Commerce"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$apr1\$[a-z0-9\\/.]{0,8}\$[a-z0-9\\/.]{22}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: 1600,
                extended: false,
                name:"MD5(APR)"
            },
            {
                john: nil,
                hashcat: 1600,
                extended: false,
                name:"Apache MD5"
            },
            {
                john: nil,
                hashcat: 1600,
                extended: true,
                name:"md5apr1"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b{smd5}[a-z0-9$\\/.]{31}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "aix-smd5",
                hashcat: 6300,
                extended: false,
                name:"AIX(smd5)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{32}:[a-f0-9]{32}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: 3721,
                extended: false,
                name:"WebEdition CMS"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{32}:.{5}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: 2811,
                extended: false,
                name:"IP.Board \u2265 v2+"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{32}:.{8}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: 2811,
                extended: false,
                name:"MyBB \u2265 v1.2+"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-z0-9]{34}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"CryptoCurrency(Adress)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{40}(:.+)?\b', Regexp::IGNORECASE),
        modes: [
            {
                name:"SHA-1",
                john: "raw-sha1",
                hashcat: 100,
                extended: false,
                description: "SHA-1 cryptographic hash function", 
                characteristics: "40 chars, hexadecimal, unsalted",
                notes: ["Used for file verification", "found in git commits and legacy certificates"],
                prefixes: ["sha1", "hash"],
                context: ["sha1", "hash"]
            },
            {
                john: nil,
                hashcat: 4500,
                extended: false,
                name:"Double SHA-1",
                context: ["sha1"]
                #prefixes: ["sha1"]
            },
            {
                name:"RIPEMD-160",
                john: "ripemd-160",
                hashcat: 6000,
                extended: false,
                characteristics: "40 chars, Bitcoin addresses, digital signatures",
                notes: ["Rarely used for passwords"]
            },
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Haval-160"
            },
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Tiger-160"
            },
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"HAS-160"
            },
            {
                john: "raw-sha1-linkedin",
                hashcat: 190,
                extended: false,
                name:"LinkedIn"
            },
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Skein-256(160)"
            },
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Skein-512(160)"
            },
            {
                john: nil,
                hashcat: nil,
                extended: true,
                name:"MangosWeb Enhanced CMS"
            },
            {
                john: nil,
                hashcat: 4600,
                extended: true,
                name:"sha1(sha1(sha1($pass)))"
            },
            {
                john: nil,
                hashcat: 4700,
                extended: true,
                name:"sha1(md5($pass))"
            },
            {
                john: nil,
                hashcat: 110,
                extended: true,
                name:"sha1($pass.$salt)"
            },
            {
                john: nil,
                hashcat: 120,
                extended: true,
                name:"sha1($salt.$pass)"
            },
            {
                john: nil,
                hashcat: 130,
                extended: true,
                name:"sha1(unicode($pass).$salt)"
            },
            {
                john: nil,
                hashcat: 140,
                extended: true,
                name:"sha1($salt.unicode($pass))"
            },
            {
                john: "hmac-sha1",
                hashcat: 150,
                extended: true,
                name:"HMAC-SHA1 (key = $pass)"
            },
            {
                john: "hmac-sha1",
                hashcat: 160,
                extended: true,
                name:"HMAC-SHA1 (key = $salt)"
            },
            {
                john: nil,
                hashcat: 4710,
                extended: true,
                name:"sha1($salt.$pass.$salt)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\\*[a-f0-9]{40}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "mysql-sha1",
                hashcat: 300,
                extended: false,
                name:"MySQL5.x"
            },
            {
                name:"MySQL4.1",
                john: "mysql-sha1",
                hashcat: 300,
                extended: false,
                description: "MySQL double SHA1 implementation", 
                characteristics: "40 chars, double SHA1 with salt",
                notes: ["Used in database export"]
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-z0-9]{43}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: 5700,
                extended: false,
                name:"Cisco-IOS(SHA-256)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b{SSHA}[a-z0-9\\/+]{38}==', Regexp::IGNORECASE),
        modes: [
            {
                john: "nsldaps",
                hashcat: 111,
                extended: false,
                name:"SSHA-1(Base64)"
            },
            {
                john: "nsldaps",
                hashcat: 111,
                extended: false,
                name:"Netscape LDAP SSHA"
            },
            {
                john: "nsldaps",
                hashcat: 111,
                extended: true,
                name:"nsldaps"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-z0-9=]{47}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "fortigate",
                hashcat: 7000,
                extended: false,
                name:"Fortigate(FortiOS)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{48}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Haval-192"
            },
            {
                john: "tiger",
                hashcat: nil,
                extended: false,
                name:"Tiger-192"
            },
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"SHA-1(Oracle)"
            },
            {
                john: "xsha",
                hashcat: 122,
                extended: false,
                name:"OSX v10.4"
            },
            {
                john: "xsha",
                hashcat: 122,
                extended: false,
                name:"OSX v10.5"
            },
            {
                john: "xsha",
                hashcat: 122,
                extended: false,
                name:"OSX v10.6"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{51}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Palshop CMS"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-z0-9]{51}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"CryptoCurrency(PrivateKey)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b{ssha1}[0-9]{2}\$[a-z0-9$\\/.]{44}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "aix-ssha1",
                hashcat: 6700,
                extended: false,
                name:"AIX(ssha1)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b0x0100[a-f0-9]{48}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "mssql05",
                hashcat: 132,
                extended: false,
                name:"MSSQL(2005)"
            },
            {
                john: "mssql05",
                hashcat: 132,
                extended: false,
                name:"MSSQL(2008)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b(\$md5,rounds=[0-9]+\$|\$md5\$rounds=[0-9]+\$|\$md5\$)[a-z0-9\\/.]{0,16}(\$|\$\$)[a-z0-9\\/.]{22}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "sunmd5",
                hashcat: 3300,
                extended: false,
                name:"Sun MD5 Crypt"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{56}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "raw-sha224",
                hashcat: nil,
                extended: false,
                name:"SHA-224"
            },
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Haval-224"
            },
            {
                john: nil,
                hashcat: 17300,
                extended: false,
                name:"SHA3-224"
            },
            {
                john: nil,
                hashcat: 17700,
                extended: false,
                name:"Keccak-224"
            },
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Skein-256(224)"
            },
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Skein-512(224)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b(\$2[axy]|\$2)\$[0-9]{2}\$[a-z0-9\\/.]{53}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "bcrypt",
                hashcat: 3200,
                extended: false,
                name:"Blowfish(OpenBSD)"
            },
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Woltlab Burning Board 4.x"
            },
            {
                john: "bcrypt",
                hashcat: 3200,
                extended: false,
                name:"bcrypt"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{40}:[a-f0-9]{16}\b', Regexp::IGNORECASE),
        modes: [
            {
                 name:"Android PIN",
                john: nil,
                hashcat: 5800,
                extended: false,
                description: "Android PIN/Password hash", 
                characteristics: "40 chars hash + 16 chars salt, SHA1 + MD5",
                notes: ["found in android gesture.key files"]
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b(S:)?[a-f0-9]{40}(:)?[a-f0-9]{20}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "oracle11",
                hashcat: 112,
                extended: false,
                name:"Oracle 11g/12c"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$bcrypt-sha256\$(2[axy]|2)\\,[0-9]+\$[a-z0-9\\/.]{22}\$[a-z0-9\\/.]{31}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"bcrypt(SHA-256)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{32}:.{3}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: 2611,
                extended: false,
                name:"vBulletin < v3.8.5"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{32}:.{30}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: 2711,
                extended: false,
                name:"vBulletin \u2265 v3.8.5"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b(\$snefru\$)?[a-f0-9]{64}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "snefru-256",
                hashcat: nil,
                extended: false,
                name:"Snefru-256"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{64}(:.+)?\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "raw-sha256",
                hashcat: 1400,
                extended: false,
                name:"SHA-256"
            },
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"RIPEMD-256"
            },
            {
                john: "haval-256-3",
                hashcat: nil,
                extended: false,
                name:"Haval-256"
            },
            {
                john: "gost",
                hashcat: 6900,
                extended: false,
                name:"GOST R 34.11-94"
            },
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"GOST CryptoPro S-Box"
            },
            {
                john: nil,
                hashcat: 17400,
                extended: false,
                name:"SHA3-256"
            },
            {
                john: "raw-keccak-256",
                hashcat: 17800,
                extended: false,
                name:"Keccak-256"
            },
            {
                john: "skein-256",
                hashcat: nil,
                extended: false,
                name:"Skein-256"
            },
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Skein-512(256)"
            },
            {
                john: nil,
                hashcat: nil,
                extended: true,
                name:"Ventrilo"
            },
            {
                john: nil,
                hashcat: 1410,
                extended: true,
                name:"sha256($pass.$salt)"
            },
            {
                john: nil,
                hashcat: 1420,
                extended: true,
                name:"sha256($salt.$pass)"
            },
            {
                john: nil,
                hashcat: 1430,
                extended: true,
                name:"sha256(unicode($pass).$salt)"
            },
            {
                john: nil,
                hashcat: 1440,
                extended: true,
                name:"sha256($salt.unicode($pass))"
            },
            {
                john: "hmac-sha256",
                hashcat: 1450,
                extended: true,
                name:"HMAC-SHA256 (key = $pass)"
            },
            {
                john: "hmac-sha256",
                hashcat: 1460,
                extended: true,
                name:"HMAC-SHA256 (key = $salt)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{32}:[a-z0-9]{32}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: 11,
                extended: false,
                name:"Joomla < v2.5.18"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{32}:[a-f0-9]{32}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"SAM(LM_Hash:NT_Hash)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b(\$chap\$0\\*)?[a-f0-9]{32}[\\*:][a-f0-9]{32}(:[0-9]{2})?\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "chap",
                hashcat: 4800,
                extended: false,
                name:"MD5(Chap)"
            },
            {
                john: "chap",
                hashcat: 4800,
                extended: false,
                name:"iSCSI CHAP Authentication"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$episerver\$\\*0\\*[a-z0-9\\/=+]+\\*[a-z0-9\\/=+]{27,28}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "episerver",
                hashcat: 141,
                extended: false,
                name:"EPiServer 6.x < v4"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b{ssha256}[0-9]{2}\$[a-z0-9$\\/.]{60}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "aix-ssha256",
                hashcat: 6400,
                extended: false,
                name:"AIX(ssha256)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{80}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"RIPEMD-320"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$episerver\$\\*1\\*[a-z0-9\\/=+]+\\*[a-z0-9\\/=+]{42,43}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "episerver",
                hashcat: 1441,
                extended: false,
                name:"EPiServer 6.x \u2265 v4"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b0x0100[a-f0-9]{88}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "mssql",
                hashcat: 131,
                extended: false,
                name:"MSSQL(2000)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{96}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "raw-sha384",
                hashcat: 10800,
                extended: false,
                name:"SHA-384"
            },
            {
                john: nil,
                hashcat: 17500,
                extended: false,
                name:"SHA3-384"
            },
            {
                john: nil,
                hashcat: 17900,
                extended: false,
                name:"Keccak-384"
            },
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Skein-512(384)"
            },
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Skein-1024(384)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b{SSHA512}[a-z0-9\\/+]{96}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "ssha512",
                hashcat: 1711,
                extended: false,
                name:"SSHA-512(Base64)"
            },
            {
                john: "ssha512",
                hashcat: 1711,
                extended: false,
                name:"LDAP(SSHA-512)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b{ssha512}[0-9]{2}\$[a-z0-9\\/.]{16,48}\$[a-z0-9\\/.]{86}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "aix-ssha512",
                hashcat: 6500,
                extended: false,
                name:"AIX(ssha512)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{128}(:.+)?\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "raw-sha512",
                hashcat: 1700,
                extended: false,
                name:"SHA-512"
            },
            {
                john: "whirlpool",
                hashcat: 6100,
                extended: false,
                name:"Whirlpool"
            },
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Salsa10"
            },         
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Salsa20"
            },
            {
                john: "raw-sha3",
                hashcat: 17600,
                extended: false,
                name:"SHA3-512"
            },
            {
                john: "raw-keccak",
                hashcat: 18000,
                extended: false,
                name:"Keccak-512"
            },
            {
                john: "skein-512",
                hashcat: nil,
                extended: false,
                name:"Skein-512"
            },
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Skein-1024(512)"
            },
            {
                john: nil,
                hashcat: 1710,
                extended: true,
                name:"sha512($pass.$salt)"
            },
            {
                john: nil,
                hashcat: 1720,
                extended: true,
                name:"sha512($salt.$pass)"
            },
            {
                john: nil,
                hashcat: 1730,
                extended: true,
                name:"sha512(unicode($pass).$salt)"
            },
            {
                john: nil,
                hashcat: 1740,
                extended: true,
                name:"sha512($salt.unicode($pass))"
            },
            {
                john: "hmac-sha512",
                hashcat: 1750,
                extended: true,
                name:"HMAC-SHA512 (key = $pass)"
            },
            {
                john: "hmac-sha512",
                hashcat: 1760,
                extended: true,
                name:"HMAC-SHA512 (key = $salt)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{136}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "xsha512",
                hashcat: 1722,
                extended: false,
                name:"OSX v10.7"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b0x0200[a-f0-9]{136}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "msql12",
                hashcat: 1731,
                extended: false,
                name:"MSSQL(2012)"
            },
            {
                john: "msql12",
                hashcat: 1731,
                extended: false,
                name:"MSSQL(2014)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$ml\$[0-9]+\$[a-f0-9]{64}\$[a-f0-9]{128}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "pbkdf2-hmac-sha512",
                hashcat: 7100,
                extended: false,
                name:"OSX v10.8"
            },
            {
                john: "pbkdf2-hmac-sha512",
                hashcat: 7100,
                extended: false,
                name:"OSX v10.9"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{256}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Skein-1024"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\bgrub\\.pbkdf2\\.sha512\\.[0-9]+\\.([a-f0-9]{128,2048}\\.|[0-9]+\\.)?[a-f0-9]{128}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: 7200,
                extended: false,
                name:"GRUB 2"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\bsha1\$[a-z0-9]+\$[a-f0-9]{40}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: 124,
                extended: false,
                name:"Django(SHA-1)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{49}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "citrix_ns10",
                hashcat: 8100,
                extended: false,
                name:"Citrix Netscaler"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$S\$[a-z0-9\\/.]{52}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "drupal7",
                hashcat: 7900,
                extended: false,
                name:"Drupal > v7.x"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$5\$(rounds=[0-9]+\$)?[a-z0-9\\/.]{0,16}\$[a-z0-9\\/.]{43}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "sha256crypt",
                hashcat: 7400,
                extended: false,
                name:"SHA-256 Crypt"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b0x[a-f0-9]{4}[a-f0-9]{16}[a-f0-9]{64}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "sybasease",
                hashcat: 8000,
                extended: false,
                name:"Sybase ASE"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$6\$(rounds=[0-9]+\$)?[a-z0-9\\/.]{0,16}\$[a-z0-9\\/.]{86}\b', Regexp::IGNORECASE),
        modes: [
            {
                name:"SHA-512 Crypt",
                john: "sha512crypt",
                hashcat: 1800,
                extended: false,
                characteristics: "$6$ prefix, includes salt, 96-106 chars", 
                notes: ["Industry standard for modern Linux systems"]
               
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$sha\$[a-z0-9]{1,16}\$([a-f0-9]{32}|[a-f0-9]{40}|[a-f0-9]{64}|[a-f0-9]{128}|[a-f0-9]{140})\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Minecraft(AuthMe Reloaded)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\bsha256\$[a-z0-9]+\$[a-f0-9]{64}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Django(SHA-256)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\bsha384\$[a-z0-9]+\$[a-f0-9]{96}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Django(SHA-384)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\bcrypt1:[a-z0-9+=]{12}:[a-z0-9+=]{12}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Clavister Secure Gateway"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{112}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Cisco VPN Client(PCF-File)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{1329}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Microsoft MSTSC(RDP-File)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[^\\\\\\/:*?\"<>|]{1,20}[:]{2,3}([^\\\\\\/:*?\"<>|]{1,20})?:[a-f0-9]{48}:[a-f0-9]{48}:[a-f0-9]{16}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "netntlm",
                hashcat: 5500,
                extended: false,
                name:"NetNTLMv1-VANILLA / NetNTLMv1+ESS"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b([^\\\\\\/:*?\"<>|]{1,20}\\\\)?[^\\\\\\/:*?\"<>|]{1,20}[:]{2,3}([^\\\\\\/:*?\"<>|]{1,20}:)?[^\\\\\\/:*?\"<>|]{1,20}:[a-f0-9]{32}:[a-f0-9]+\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "netntlmv2",
                hashcat: 5600,
                extended: false,
                name:"NetNTLMv2"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$(krb5pa|mskrb5)\$([0-9]{2})?\$.+\$[a-f0-9]{1,}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "krb5pa-md5",
                hashcat: 7500,
                extended: false,
                name:"Kerberos 5 AS-REQ Pre-Auth"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$scram\$[0-9]+\$[a-z0-9\\/.]{16}\$sha-1=[a-z0-9\\/.]{27},sha-256=[a-z0-9\\/.]{43},sha-512=[a-z0-9\\/.]{86}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"SCRAM Hash"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{40}:[a-f0-9]{0,32}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: 7600,
                extended: false,
                name:"Redmine Project Management Web App"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b(.+)?\$[a-f0-9]{16}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "sapb",
                hashcat: 7700,
                extended: false,
                name:"SAP CODVN B (BCODE)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b(.+)?\$[a-f0-9]{40}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "sapg",
                hashcat: 7800,
                extended: false,
                name:"SAP CODVN F/G (PASSCODE)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b(.+\$)?[a-z0-9\\/.+]{30}(:.+)?\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "md5",
                hashcat: 22,
                extended: false,
                name:"Juniper Netscreen/SSG(ScreenOS)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b0x[a-f0-9]{60}\\s0x[a-f0-9]{40}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: 123,
                extended: false,
                name:"EPi"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{40}:[^*]{1,25}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: 121,
                extended: false,
                name:"SMF \u2265 v1.1"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b(\$wbb3\$\\*1\\*)?[a-f0-9]{40}[:*][a-f0-9]{40}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "wbb3",
                hashcat: 8400,
                extended: false,
                name:"Woltlab Burning Board 3.x"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{130}(:[a-f0-9]{40})?\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: 7300,
                extended: false,
                name:"IPMI2 RAKP HMAC-SHA1"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{32}:[0-9]+:[a-z0-9_.+\\-]+@[a-z0-9\\-]+\\.[a-z0-9\\-.]+\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: 6800,
                extended: false,
                name:"Lastpass"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-z0-9\\/.]{16}([:$].{1,})?\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "asa-md5",
                hashcat: 2410,
                extended: false,
                name:"Cisco-ASA(MD5)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$vnc\$\\*[a-f0-9]{32}\\*[a-f0-9]{32}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "vnc",
                hashcat: nil,
                extended: false,
                name:"VNC"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-z0-9]{32}(:([a-z0-9\\-]+\\.)?[a-z0-9\\-.]+\\.[a-z]{2,7}:.+:[0-9]+)?\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: 8300,
                extended: false,
                name:"DNSSEC(NSEC3)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b(user-.+:)?\$racf\$\\*.+\\*[a-f0-9]{16}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "racf",
                hashcat: 8500,
                extended: false,
                name:"RACF"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$3\$\$[a-f0-9]{32}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"NTHash(FreeBSD Variant)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$sha1\$[0-9]+\$[a-z0-9\\/.]{0,64}\$[a-z0-9\\/.]{28}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "sha1crypt",
                hashcat: nil,
                extended: false,
                name:"SHA-1 Crypt"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{70}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "hmailserver",
                hashcat: 1421,
                extended: false,
                name:"hMailServer"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[:\$][AB][:\$]([a-f0-9]{1,8}[:\$])?[a-f0-9]{32}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "mediawiki",
                hashcat: 3711,
                extended: false,
                name:"MediaWiki"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{140}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Minecraft(xAuth)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$pbkdf2(-sha1)?\$[0-9]+\$[a-z0-9\\/.]+\$[a-z0-9\\/.]{27}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"PBKDF2-SHA1(Generic)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$pbkdf2-sha256\$[0-9]+\$[a-z0-9\\/.]+\$[a-z0-9\\/.]{43}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "pbkdf2-hmac-sha256",
                hashcat: nil,
                extended: false,
                name:"PBKDF2-SHA256(Generic)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$pbkdf2-sha512\$[0-9]+\$[a-z0-9\\/.]+\$[a-z0-9\\/.]{86}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"PBKDF2-SHA512(Generic)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$p5k2\$[0-9]+\$[a-z0-9\\/+=-]+\$[a-z0-9\\/+-]{27}=\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"PBKDF2(Cryptacular)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$p5k2\$[0-9]+\$[a-z0-9\\/.]+\$[a-z0-9\\/.]{32}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"PBKDF2(Dwayne Litzenberger)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b{FSHP[0123]\\|[0-9]+\\|[0-9]+}[a-z0-9\\/+=]+\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Fairly Secure Hashed Password"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$PHPS\$.+\$[a-f0-9]{32}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "phps",
                hashcat: 2612,
                extended: false,
                name:"PHPS"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[0-9]{4}:[a-f0-9]{16}:[a-f0-9]{2080}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: 6600,
                extended: false,
                name:"1Password(Agile Keychain)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{64}:[a-f0-9]{32}:[0-9]{5}:[a-f0-9]{608}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: 8200,
                extended: false,
                name:"1Password(Cloud Keychain)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{256}:[a-f0-9]{256}:[a-f0-9]{16}:[a-f0-9]{16}:[a-f0-9]{320}:[a-f0-9]{16}:[a-f0-9]{40}:[a-f0-9]{40}:[a-f0-9]{32}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: 5300,
                extended: false,
                name:"IKE-PSK MD5"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{256}:[a-f0-9]{256}:[a-f0-9]{16}:[a-f0-9]{16}:[a-f0-9]{320}:[a-f0-9]{16}:[a-f0-9]{40}:[a-f0-9]{40}:[a-f0-9]{40}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: 5400,
                extended: false,
                name:"IKE-PSK SHA1"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-z0-9\\/+]{27}=\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: 133,
                extended: false,
                name:"PeopleSoft"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\bcrypt\$[a-f0-9]{5}\$[a-z0-9\\/.]{13}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Django(DES Crypt Wrapper)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b(\$django\$\\*1\\*)?pbkdf2_sha256\$[0-9]+\$[a-z0-9]+\$[a-z0-9\\/+=]{44}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "django",
                hashcat: 10000,
                extended: false,
                name:"Django(PBKDF2-HMAC-SHA256)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\bpbkdf2_sha1\$[0-9]+\$[a-z0-9]+\$[a-z0-9\\/+=]{28}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Django(PBKDF2-HMAC-SHA1)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\bbcrypt(\$2[axy]|\$2)\$[0-9]{2}\$[a-z0-9\\/.]{53}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Django(bcrypt)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\bmd5\$[a-f0-9]+\$[a-f0-9]{32}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"Django(MD5)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\\{PKCS5S2\\}[a-z0-9\\/+]{64}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"PBKDF2(Atlassian)"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\bmd5[a-f0-9]{32}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: nil,
                extended: false,
                name:"PostgreSQL MD5"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\\([a-z0-9\\/+]{49}\\)\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: 9100,
                extended: false,
                name:"Lotus Notes/Domino 8"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\bSCRYPT:[0-9]{1,}:[0-9]{1}:[0-9]{1}:[a-z0-9:\\/+=]{1,}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: 8900,
                extended: false,
                name:"scrypt"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$8\$[a-z0-9\\/.]{14}\$[a-z0-9\\/.]{43}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "cisco8",
                hashcat: 9200,
                extended: false,
                name:"Cisco Type 8"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$9\$[a-z0-9\\/.]{14}\$[a-z0-9\\/.]{43}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "cisco9",
                hashcat: 9300,
                extended: false,
                name:"Cisco Type 9"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$office\$\\*2007\\*[0-9]{2}\\*[0-9]{3}\\*[0-9]{2}\\*[a-z0-9]{32}\\*[a-z0-9]{32}\\*[a-z0-9]{40}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "office",
                hashcat: 9400,
                extended: false,
                name:"Microsoft Office 2007"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$office\$\\*2010\\*[0-9]{6}\\*[0-9]{3}\\*[0-9]{2}\\*[a-z0-9]{32}\\*[a-z0-9]{32}\\*[a-z0-9]{64}\b', Regexp::IGNORECASE),
        modes: [
            {
                name:"Microsoft Office 2010",
                john: nil,
                hashcat: 9500,
                extended: false
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$office\$\\*2013\\*[0-9]{6}\\*[0-9]{3}\\*[0-9]{2}\\*[a-z0-9]{32}\\*[a-z0-9]{32}\\*[a-z0-9]{64}\b', Regexp::IGNORECASE),
        modes: [
            {
                name:"Microsoft Office 2013",
                john: nil,
                hashcat: 9600,
                extended: false
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$fde\$[0-9]{2}\$[a-f0-9]{32}\$[0-9]{2}\$[a-f0-9]{32}\$[a-f0-9]{3072}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "fde",
                hashcat: 8800,
                extended: false,
                name:"Android FDE \u2264 4.3"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$oldoffice\$[01]\\*[a-f0-9]{32}\\*[a-f0-9]{32}\\*[a-f0-9]{32}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "oldoffice",
                hashcat: 9700,
                extended: false,
                name:"Microsoft Office \u2264 2003 (MD5+RC4)"
            },
            {
                john: "oldoffice",
                hashcat: 9710,
                extended: false,
                name:"Microsoft Office \u2264 2003 (MD5+RC4) collider-mode #1"
            },
            {
                john: "oldoffice",
                hashcat: 9720,
                extended: false,
                name:"Microsoft Office \u2264 2003 (MD5+RC4) collider-mode #2"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$oldoffice\$[34]\\*[a-f0-9]{32}\\*[a-f0-9]{32}\\*[a-f0-9]{40}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: 9800,
                extended: false,
                name:"Microsoft Office \u2264 2003 (SHA1+RC4)"
            },
            {
                john: nil,
                hashcat: 9810,
                extended: false,
                name:"Microsoft Office \u2264 2003 (SHA1+RC4) collider-mode #1"
            },
            {
                john: nil,
                hashcat: 9820,
                extended: false,
                name:"Microsoft Office \u2264 2003 (SHA1+RC4) collider-mode #2"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b(\$radmin2\$)?[a-f0-9]{32}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "radmin",
                hashcat: 9900,
                extended: false,
                name:"RAdmin v2.x"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b{x-issha,\\s[0-9]{4}}[a-z0-9\\/+=]+\b', Regexp::IGNORECASE),
        modes: [
            {
                john: "saph",
                hashcat: 10300,
                extended: false,
                name:"SAP CODVN H (PWDSALTEDHASH) iSSHA-1"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$cram_md5\$[a-z0-9\\/+=-]+\$[a-z0-9\\/+=-]{52}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: 10200,
                extended: false,
                name:"CRAM-MD5"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{16}:2:4:[a-f0-9]{32}\b', Regexp::IGNORECASE),
        modes: [
            {
                john: nil,
                hashcat: 10100,
                extended: false,
                name:"SipHash"
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-f0-9]{4,}\b', Regexp::IGNORECASE),
        modes: [
            {
                name:"Cisco Type 7",
                john: nil,
                hashcat: nil,
                extended: true
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b[a-z0-9\\/.]{13,}\b', Regexp::IGNORECASE),
        modes: [
            {
                name:"BigCrypt",
                john: "bigcrypt",
                hashcat: nil,
                extended: true,
                description: "Extended DES crypt — 13+ chars, extended length",
                notes: ["Rarely used", "Used in some Unix variants"], 
                common_sources: ["some Unix variants"], 
                context: ["unix", "extended"]
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b(\$cisco4\$)?[a-z0-9\\/.]{43}\b', Regexp::IGNORECASE),
        modes: [
            {
                name:"Cisco Type 4",
                john: "cisco4",
                hashcat: nil,
                extended: false
            }
        ]
    },
    {
        extract_regex: Regexp.new('\bbcrypt_sha256\$\$(2[axy]|2)\$[0-9]+\$[a-z0-9\\/.]{53}\b', Regexp::IGNORECASE),
        modes: [
            {
                name:"Django(bcrypt-SHA256)",
                john: nil,
                hashcat: nil,
                extended: false
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$postgres\$.[^\\*]+[*:][a-f0-9]{1,32}[*:][a-f0-9]{32}\b', Regexp::IGNORECASE),
        modes: [
            {
                name:"PostgreSQL Challenge-Response Authentication (MD5)",
                john: "postgres",
                hashcat: 11100,
                extended: false
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$siemens-s7\$[0-9]{1}\$[a-f0-9]{40}\$[a-f0-9]{40}\b', Regexp::IGNORECASE),
        modes: [
            {
                name:"Siemens-S7",
                john: "siemens-s7",
                hashcat: nil,
                extended: false
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b(\$pst\$)?[a-f0-9]{8}\b', Regexp::IGNORECASE),
        modes: [
            {
                name:"Microsoft Outlook PST",
                john: nil,
                hashcat: nil,
                extended: false
            }
        ]
    },
    {
        extract_regex: Regexp.new('\bsha256[:$][0-9]+[:$][a-z0-9\\/+]+[:$][a-z0-9\\/+]{32,128}\b', Regexp::IGNORECASE),
        modes: [
            {
                name:"PBKDF2-HMAC-SHA256(PHP)",
                john: nil,
                hashcat: 10900,
                extended: false
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b(\$dahua\$)?[a-z0-9]{8}\b', Regexp::IGNORECASE),
        modes: [
            {
                name:"Dahua",
                john: "dahua",
                hashcat: nil,
                extended: false
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$mysqlna\$[a-f0-9]{40}[:*][a-f0-9]{40}\b', Regexp::IGNORECASE),
        modes: [
            {
                 name:"MySQL Challenge-Response Authentication (SHA1)",
                john: nil,
                hashcat: 11200,
                extended: false
            }
        ]
    },
    {
        extract_regex: Regexp.new('\b\$pdf\$[24]\\*[34]\\*128\\*[0-9-]{1,5}\\*1\\*(16|32)\\*[a-f0-9]{32,64}\\*32\\*[a-f0-9]{64}\\*(8|16|32)\\*[a-f0-9]{16,64}\b', Regexp::IGNORECASE),
        modes: [
            {
                name:"PDF 1.4 - 1.6 (Acrobat 5 - 8)",
                john: "pdf",
                hashcat: 10500,
                extended: false
            }
        ]
    }
  ].freeze
end