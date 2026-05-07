# HEITT (formerly Hashpeek)
## Hash Extraction, Identification & Triage Tool
**Heitt** (pronounced as "8" with a preceeding "h") is a tool as well as a library for hash extraction, identification and grouping 

---
**NOTE:** This project was previously named **Hashpeek**. It has being renamed to **HEITT** to better reflect what the tool actually does and to avoid confusion with unrelated projects sharing the same name.

---

## Why HEITT
One will wonder, **"why a new hash identifier (heitt), aren't there enough of this out there?"** 

**You are right to question the existence of this tool**.

There are many hash identifiers out there but they seem to have one limitation or the other.
1. Some don't accept input via stdin making it somehow difficult for scripting.
2. Others too show outputs that are a hassle to grep (you need regex gymnastics to grep).
3. Some too only accept hashes (no files) and those that accept hashfiles are more likely to spam your screen with redundant results(results-per-hash spam). **The main reason heitt was built**
4. Inability to extract hashes from logs, dumps and structured data (shadow files, etc)

Those are the issues or limitations hashpeek is here to handle.


## TODOS
- Add external database support (only in json). - **DONE**
- change default format to tree format - **DONE**
- Drop hex and context Extraction for an efficient one. - **IN PROGRESS**
- Add contexts and metadata per hash to the hash database. - **IN PROGRESS**
- Make the tool faster
- Fix bugs
- Accept generic extraction (not necessarily a hash) through external databases. - **STILL ON THE FENCE**

## Library Usage
### Identification (Single Hash)
```ruby
require 'heitt' #currently heitt is not a gem yet

analyzer = HEITT::Identifier.new()
#OR for a custom database
# analyzer = HEITT::Identifier.new("/path_to/my_custom/database.json")
result = analyzer.identify("eeab875587d2edefa27ddfce574dc8f7")
#tree output
puts result.tree_format
#json output
puts result.json_format
```

---

### Identification (Stream/Array of Hashes)
```ruby
require 'heitt'  # Not a gem yet

analyzer = HEITT::Identifier.new
# Stream identification
analyzer << "eeab875587d2edefa27ddfce574dc8f7" << "edc13c43bc8cd8ba64c132ca92709f63"
#get results 
result = analyzer.finalize
puts result.tree_format

# OR Array Identification
ident = HEITT::Identifier.new
# Call batch_identify as a function
result = ident.batch_identify(["eeab875587d2edefa27ddfce574dc8f7", "edc13c43bc8cd8ba64c132ca92709f63"])
puts result.tree_format

# OR call batch_identify as a block
ident.batch_identify(["eeab875587d2edefa27ddfce574dc8f7", "edc13c43bc8cd8ba64c132ca92709f63"]) do |single|
  puts single.tree_format
end
```

---

### Hash Extraction
For field parsing, when index is greater than expected field, it fallback to regex extraction
```ruby
require 'heitt'

extractor = HEITT::Extractor.new
# OR with a custom database
#extractor = HEITT::Extractor.new("/path_to/my_custom/database.json")

#text extraction (regex)
puts extractor.scan_text("Hey, found this: 31ebdfce8b77ac49d7f5506dd1495830")

#text extraction (field_parsing)
puts extractor.scan_text("Bob:31ebdfce8b77ac49d7f5506dd1495830:guest", delimiter: ":", index: 1)

#file extraction (regex)
puts extractor.scan_file("hashes.txt")

#file extraction (field parsing)
puts extractor.scan_file("hashes.txt", delimiter: ":", index: 2)

# OR 
# It accepts files and hashstring
extractor << "31eb" << "deff" << "hashes.txt"
puts extractor.finalize

```

---
## Code
```ruby
require 'heitt'

analyze = HEITT::Identifier.new()
hashes = ["a95c9b6ab0e338f225f5f7595c7674b7","b1946ac92492d2347c6235b4d2611184", "5891b5b522d5df086d0ff0b110fbd9d21bb4fc7163af34d08286a2e846f6be03", "e73b7fc75f15461894e98ce26c773e9e"]
puts analyze.batch_identify(hashes).tree_format
```

## Output
```bash
[GROUPED HASHES]
├─ HASH CLUSTER 1
│  ├─ a95c9b6ab0e338f225f5f7595c7674b7
│  ├─ b1946ac92492d2347c6235b4d2611184
│  └─ e73b7fc75f15461894e98ce26c773e9e
└─ HASH CLUSTER 2
   └─ 5891b5b522d5df086d0ff0b110fbd9d21bb4fc7163af34d08286a2e846f6be03


HASH CLUSTER 1: 3 OF 4 HASHES ARE

[CANDIDATE 1: MD2]
├─ Hashcat Mode: --
└─ John Format: md2

[CANDIDATE 2: MD5]
├─ Hashcat Mode: 0
├─ John Format: raw-md5
├─ Description: MD5 cryptographic hash function
├─ Characteristics: 32 chars, hexadecimal, unsalted
└─ Notes:
   ├─ Used as checksum to verify data or file integrity
   └─ MD5 is cryptographically broken as it is vulnerable to collision attacks

[CANDIDATE 3: MD4]
├─ Hashcat Mode: 900
├─ John Format: raw-md4
└─ Characteristics: 32 chars, legacy Microsoft systems

[CANDIDATE 4: Double MD5]
├─ Hashcat Mode: 2600
└─ John Format: --

[CANDIDATE 5: LM]
├─ Hashcat Mode: 3000
├─ John Format: lm
├─ Description: LAN Manager hash
├─ Characteristics: 16 hex chars, all uppercase, split password
└─ Notes:
   ├─ Mainly found in Windows SAM files(legacy Windows)
   ├─ Very weak
   ├─ no lowercase
   └─ split passwords

[CANDIDATE 6: LM]
├─ Hashcat Mode: 3000
├─ John Format: lm
├─ Description: Windows LAN Manager hash
├─ Characteristics: 32 chars, all uppercase, no lowercase
└─ Notes:
   └─ Mainly found in Windows SAM files(legacy Windows)

[CANDIDATE 7: RIPEMD-128]
├─ Hashcat Mode: --
└─ John Format: ripemd-128

[CANDIDATE 8: Haval-128]
├─ Hashcat Mode: --
└─ John Format: haval-128-4

[CANDIDATE 9: Tiger-128]
├─ Hashcat Mode: --
└─ John Format: --

[CANDIDATE 10: Skein-256(128)]
├─ Hashcat Mode: --
└─ John Format: --

[CANDIDATE 11: Skein-512(128)]
├─ Hashcat Mode: --
└─ John Format: --

[CANDIDATE 12: Lotus Notes/Domino 5]
├─ Hashcat Mode: 8600
└─ John Format: lotus5

[CANDIDATE 13: Skype]
├─ Hashcat Mode: 23
└─ John Format: --

[CANDIDATE 14: ZipMonster]
├─ Hashcat Mode: --
└─ John Format: --

[CANDIDATE 15: PrestaShop]
├─ Hashcat Mode: 11000
└─ John Format: --

[CANDIDATE 16: md5(md5(md5($pass)))]
├─ Hashcat Mode: 3500
└─ John Format: --

[CANDIDATE 17: md5(strtoupper(md5($pass)))]
├─ Hashcat Mode: 4300
└─ John Format: --

[CANDIDATE 18: md5(sha1($pass))]
├─ Hashcat Mode: 4400
└─ John Format: --

[CANDIDATE 19: md5($pass.$salt)]
├─ Hashcat Mode: 10
└─ John Format: --

[CANDIDATE 20: md5($salt.$pass)]
├─ Hashcat Mode: 20
└─ John Format: --

[CANDIDATE 21: md5(unicode($pass).$salt)]
├─ Hashcat Mode: 30
└─ John Format: --

[CANDIDATE 22: md5($salt.unicode($pass))]
├─ Hashcat Mode: 40
└─ John Format: --

[CANDIDATE 23: HMAC-MD5 (key = $pass)]
├─ Hashcat Mode: 50
└─ John Format: hmac-md5

[CANDIDATE 24: HMAC-MD5 (key = $salt)]
├─ Hashcat Mode: 60
└─ John Format: hmac-md5

[CANDIDATE 25: md5(md5($salt).$pass)]
├─ Hashcat Mode: 3610
└─ John Format: --

[CANDIDATE 26: md5($salt.md5($pass))]
├─ Hashcat Mode: 3710
└─ John Format: --

[CANDIDATE 27: md5($pass.md5($salt))]
├─ Hashcat Mode: 3720
└─ John Format: --

[CANDIDATE 28: md5($salt.$pass.$salt)]
├─ Hashcat Mode: 3810
└─ John Format: --

[CANDIDATE 29: md5(md5($pass).md5($salt))]
├─ Hashcat Mode: 3910
└─ John Format: --

[CANDIDATE 30: md5($salt.md5($salt.$pass))]
├─ Hashcat Mode: 4010
└─ John Format: --

[CANDIDATE 31: md5($salt.md5($pass.$salt))]
├─ Hashcat Mode: 4110
└─ John Format: --

[CANDIDATE 32: md5($username.0.$pass)]
├─ Hashcat Mode: 4210
└─ John Format: --

[CANDIDATE 33: Snefru-128]
├─ Hashcat Mode: --
└─ John Format: snefru-128

[CANDIDATE 34: NTLM]
├─ Hashcat Mode: 1000
├─ John Format: nt
├─ Description: Windows NTLM authentication hash
├─ Characteristics: 32 chars, Windows authentication, based on MD4
└─ Notes:
   ├─ Hashcat Mode: 5600 (NetNTLMv2) - if network captured
   ├─ Hashcat Mode: 5500 (NetNTLMv1/NetNTLMv1+ESS) - legacy versions
   ├─ John Format: netntlm (for network hashes)
   └─ John Format: netntlmv2 (v2 hashes)

[CANDIDATE 35: Domain Cached Credentials]
├─ Hashcat Mode: 1100
└─ John Format: mscach

[CANDIDATE 36: Domain Cached Credentials 2]
├─ Hashcat Mode: 2100
└─ John Format: mscach2

[CANDIDATE 37: DNSSEC(NSEC3)]
├─ Hashcat Mode: 8300
└─ John Format: --

[CANDIDATE 38: RAdmin v2.x]
├─ Hashcat Mode: 9900
└─ John Format: radmin

[CANDIDATE 39: Cisco Type 7]
├─ Hashcat Mode: --
└─ John Format: --

[CANDIDATE 40: BigCrypt]
├─ Hashcat Mode: --
├─ John Format: bigcrypt
├─ Description: Extended DES crypt
├─ Characteristics: 13+ chars, extended length
└─ Notes:
   ├─ Rarely used
   └─ Used in some Unix variants




HASH CLUSTER 2: 1 OF 4 HASHES ARE

[CANDIDATE 1: Snefru-256]
├─ Hashcat Mode: --
└─ John Format: snefru-256

[CANDIDATE 2: SHA-256]
├─ Hashcat Mode: 1400
└─ John Format: raw-sha256

[CANDIDATE 3: RIPEMD-256]
├─ Hashcat Mode: --
└─ John Format: --

[CANDIDATE 4: Haval-256]
├─ Hashcat Mode: --
└─ John Format: haval-256-3

[CANDIDATE 5: GOST R 34.11-94]
├─ Hashcat Mode: 6900
└─ John Format: gost

[CANDIDATE 6: GOST CryptoPro S-Box]
├─ Hashcat Mode: --
└─ John Format: --

[CANDIDATE 7: SHA3-256]
├─ Hashcat Mode: 17400
└─ John Format: --

[CANDIDATE 8: Keccak-256]
├─ Hashcat Mode: 17800
└─ John Format: raw-keccak-256

[CANDIDATE 9: Skein-256]
├─ Hashcat Mode: --
└─ John Format: skein-256

[CANDIDATE 10: Skein-512(256)]
├─ Hashcat Mode: --
└─ John Format: --

[CANDIDATE 11: Ventrilo]
├─ Hashcat Mode: --
└─ John Format: --

[CANDIDATE 12: sha256($pass.$salt)]
├─ Hashcat Mode: 1410
└─ John Format: --

[CANDIDATE 13: sha256($salt.$pass)]
├─ Hashcat Mode: 1420
└─ John Format: --

[CANDIDATE 14: sha256(unicode($pass).$salt)]
├─ Hashcat Mode: 1430
└─ John Format: --

[CANDIDATE 15: sha256($salt.unicode($pass))]
├─ Hashcat Mode: 1440
└─ John Format: --

[CANDIDATE 16: HMAC-SHA256 (key = $pass)]
├─ Hashcat Mode: 1450
└─ John Format: hmac-sha256

[CANDIDATE 17: HMAC-SHA256 (key = $salt)]
├─ Hashcat Mode: 1460
└─ John Format: hmac-sha256

[CANDIDATE 18: Cisco Type 7]
├─ Hashcat Mode: --
└─ John Format: --

[CANDIDATE 19: BigCrypt]
├─ Hashcat Mode: --
├─ John Format: bigcrypt
├─ Description: Extended DES crypt
├─ Characteristics: 13+ chars, extended length
└─ Notes:
   ├─ Rarely used
   └─ Used in some Unix variants


```

## Installation
```bash
git clone https://github.com/jobotow/heitt
```
