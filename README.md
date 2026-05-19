# HEITT (formerly Hashpeek)
## Hash Extraction, Identification & Triage Tool
**Heitt** is a tool as well as a library that handles hash extraction, identification and grouping 

---
**NOTE:** This project was previously named **Hashpeek**. It has being renamed to **HEITT** to better reflect what the tool actually does and to avoid confusion with unrelated projects sharing the same name.


---

## Why HEITT
One will wonder, **"why a new hash identifier (heitt), aren't there enough of this out there?"** 

**You are right to question the existence of this tool**.
**But I want to tell you, this is not "yet another hash identification tool"**

There are many hash identifiers out there but they seem to have one limitation or the other.
1. Some don't accept input via stdin making it somehow difficult for scripting.
2. Others too show outputs that are a hassle to grep (you need regex gymnastics to grep).
3. Some too only accept hashes (no files) and those that accept hashfiles are more likely to spam your screen with redundant results(results-per-hash spam). **The main reason heitt was built**
4. Inability to extract hashes from logs, dumps and structured data (shadow files, etc)

Those are the issues or limitations hashpeek is here to handle.

## Features
- Context-aware extraction and identification: Assigns confidence based on surrounding text in a given file. Just provide the file and let heitt handle it from there.
- Entropy filtering to eliminate false positives
- Supports 276 hashtypes - Adapted from hashid
- Hash Clustering: Groups hashes that share the same top candidate, eliminating per-hash spam
- Cli tool as well as a library.
- Tree output for human readability, JSON output for scripting and piping (automatic when output is redirected)
- Hashcat modes and John the Ripper formats per candidate
- Extraction from dirty input: HEITT can accurately identify hashes based on surrounding context. This means it thrives on raw, unprocessed input (logs, application output, packet captures, etc). The dirtier the output, the more context HEITT has to work with, and the more accurate its identification becomes. 

## NOTE: 
This tool prioritizes context-based identification via extraction over statistical popularity or length checks. It has being re-written in ruby from the ground up


## TODOS
- Add external database support (only in json). - **DONE**
- change default format to tree format - **DONE**
- Drop hex and context Extraction for an efficient one. - **ALMOST DONE**
- Add contexts and metadata per hash to the hash database. - **IN PROGRESS**
- Add Entropy filtration - **IN PROGRESS**
- Make the tool faster
- Fix bugs **A NEVER FINISHING TASK**
- Accept generic extraction (not necessarily a hash) through external databases. - **ON THE FENCE**

---

## Installation
```bash
sudo gem install heitt
```

---
## Library Usage:
### Basic

```ruby
require 'heitt'

results = HEITT::Scanner.scan("auth.log")
groups = HEITT::Grouper.group(results)
puts HEITT::Formatter.tree(groups)
# OR for json
puts HEITT::Formatter.json(groups)
```

---

### Custom Options
```ruby
require 'heitt'
# Adjust entropy threshold and add custom database
results = HEITT::Scanner.scan("auth.log", database: "path_to/my_custom/database.json", min_entropy: 4.0)
groups = HEITT::Grouper.group(results)

# Show extended and regex matched candidates
puts HEITT::Formatter.tree(groups, extended: true, show_regex_match: true)
# Show verbose output
puts HEITT::Formatter.tree(groups, verbose: true)

# For json
puts HEITT::Formatter.json(groups, extended: true, show_regex_match: true)
```

---


## Command
```bash
heitt hashes.txt
```

---

## File Content
``` bash
Alice:aabbcc:guest, md5= fbe0aa536fc349cbdc451ff5970f9357 hash= e452794a88a7a7067ee9846d1231cc99 Bob:aabb:user
bluetooth bluetooth Alice:aabbcc:guest Alice:aacc
# User login attempts
fcs-16:aaff
#Entropy should filter it out md5=deadbeefdeadbeefdeadbeefdeadbeef [INFO] 2025-08-25T10:00:01Z New user 'alice' created. Temp pass: welcome123
[DEBUG] 2025-08-25T10:01:12Z Session token: nt:5f4dcc3b5aa765d61d8327deb882cf99###
[ERROR] 2025-08-25T10:02:15Z Password reset failed for 'svc_user'. hash:f572d396fae9206628714fb2ce00f72e94f2258f
[WARN] 2025-08-25T10:03:33Z User 'bob' failed login. Token: ####e99a18c428cb38d5f260853678922e03###
Some debug info: 0x4f2a1b alright this is descript G8n0KRCTGO8SY [INFO] Miscellaneous logs ####c3fcd3d76192e4007dfb496cca67e13b###
# End of log#

```

## Output (use verbose mode to show descriptions, notes and characteristics)
```bash
[CLUSTERED HASHES]
├── HASH CLUSTER 1
│   ├── aabb
│   ├── aacc
│   └── 2025
│     
├── HASH CLUSTER 2
│   └── aaff
│     
├── HASH CLUSTER 3
│   ├── fbe0aa536fc349cbdc451ff5970f9357
│   ├── e452794a88a7a7067ee9846d1231cc99
│   ├── e99a18c428cb38d5f260853678922e03
│   └── c3fcd3d76192e4007dfb496cca67e13b
│     
├── HASH CLUSTER 4
│   └── 5f4dcc3b5aa765d61d8327deb882cf99
│     
└── HASH CLUSTER 5
    └── f572d396fae9206628714fb2ce00f72e94f2258f
      


[HASH CLUSTER 1]
└── [CANDIDATE 1: CRC-16-CCITT — CONFIDENCE: HIGH]
    ├── Hashcat Mode: --
    └── John Format: --
      


[HASH CLUSTER 2]
├── [CANDIDATE 1: FCS-16 — CONFIDENCE: HIGH]
│   ├── Hashcat Mode: --
│   └── John Format: --
│     
└── [CANDIDATE 2: CRC-16-CCITT — CONFIDENCE: MEDIUM-LOW]
    ├── Hashcat Mode: --
    └── John Format: --
      


[HASH CLUSTER 3]
├── [CANDIDATE 1: MD5 — CONFIDENCE: HIGH]
│   ├── Hashcat Mode: 0
│   └── John Format: raw-md5
│     
├── [CANDIDATE 2: MD4 — CONFIDENCE: MEDIUM-HIGH]
│   ├── Hashcat Mode: 900
│   └── John Format: raw-md4
│     
└── [CANDIDATE 3: NTLM — CONFIDENCE: MEDIUM-LOW]
    ├── Hashcat Mode: 1000
    └── John Format: nt
      


[HASH CLUSTER 4]
├── [CANDIDATE 1: NTLM — CONFIDENCE: HIGH]
│   ├── Hashcat Mode: 1000
│   └── John Format: nt
│     
├── [CANDIDATE 2: MD5 — CONFIDENCE: HIGH]
│   ├── Hashcat Mode: 0
│   └── John Format: raw-md5
│     
└── [CANDIDATE 3: MD4 — CONFIDENCE: MEDIUM-HIGH]
    ├── Hashcat Mode: 900
    └── John Format: raw-md4
      


[HASH CLUSTER 5]
└── [CANDIDATE 1: SHA-1 — CONFIDENCE: HIGH]
    ├── Hashcat Mode: 100
    └── John Format: raw-sha1
    

```

---

## Help Output
```

   =========================================================================    
         HEITT  v0.4.3 - Hash Extraction, Identification & Triage Tool          
   =========================================================================    

Extract and identify hashes from any input.
Input may be hash string, a file or read from stin

Usage: heitt [<INPUT(S)>] [OPTIONS]

ARGUMENTS:
    [<INPUT(S)>]                     Hash string or filepath

GENERAL OPTIONS:
    -h, --help                       Show this help message and exit
    -v, --version                    Show version information


OUTPUT OPTIONS:
    -V, --verbose                    Show description and notes for each candidate
    -j, --json                       Output in json format
    -o, --output FILEPATH            File to write output to

FILTERING OPTIONS:
    -e, --extended                   Show extended candidates
    -r, --regex-match                Show regex-matched candidates
    -E, --min-entropy FLOAT          Minimum entropy threshold[default: 3.5]

DATABASE OPTIONS:
    -D, --database FILEPATH          Use custom database

EXAMPLES:
    heitt 634d398e96eb1550956b8128cfeb0747 -r
    heitt auth.log
    heitt auth.log --json --output result.json
    heitt auth.log --extended --regex-match
    heitt auth.log --min-entropy 4.0
    cat auth.log | heitt 


NOTES:
    JSON format is default when output is redirected or piped.
    Regex-match candidates are hidden by default, use '-r' to show.
    Running without input starts interactive mode.
   =========================================================================    
                                  END OF HELP                                   
   =========================================================================    
   
```