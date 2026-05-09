# HEITT (formerly Hashpeek)
## Hash Extraction, Identification & Triage Tool
**Heitt** (pronounced as "8" with a preceeding "h") is a tool that handles hash extraction, identification and grouping 

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

## TLDR: 
This tool prioritizes context-based identification (via extraction) over statistical popularity or length checks.


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

## File Content
``` bash
Alice:aabbcc:guest, md5= fbe0aa536fc349cbdc451ff5970f9357 hash= e452794a88a7a7067ee9846d1231cc99 Bob:aabb:user
bluetooth bluetooth Alice:aabbcc:guest Alice:aacc
# User login attempts
fcs-16:aaff
#Entropy should filter it out md5=deadbeefdeadbeefdeadbeefdeadbeef [INFO] 2025-08-25T10:00:01Z New user 'alice' created. Temp pass: welcome123
[DEBUG] 2025-08-25T10:01:12Z Session token: nt:5f4dcc3b5aa765d61d8327deb882cf99###
[ERROR] 2025-08-25T10:02:15Z Password reset failed for 'svc_user'. hash:d6e0d2c1a5e89c5c7b6b9bccb8b8b8b8b8b8b8b8
Random note: nothing to see here 12345
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
│   └── aabbcc
│     
├── HASH CLUSTER 4
│   ├── G8n0KRCTGO8SY
│   └── Miscellaneous
│     
├── HASH CLUSTER 5
│   ├── fbe0aa536fc349cbdc451ff5970f9357
│   ├── e452794a88a7a7067ee9846d1231cc99
│   ├── deadbeefdeadbeefdeadbeefdeadbeef
│   ├── e99a18c428cb38d5f260853678922e03
│   └── c3fcd3d76192e4007dfb496cca67e13b
│     
├── HASH CLUSTER 6
│   └── 5f4dcc3b5aa765d61d8327deb882cf99
│     
└── HASH CLUSTER 7
    └── d6e0d2c1a5e89c5c7b6b9bccb8b8b8b8b8b8b8b8
      


[HASH CLUSTER 1]
├── [CANDIDATE 1: CRC-16-CCITT — CONFIDENCE: HIGH]
│   ├── Hashcat Mode: --
│   └── John Format: --
│     
├── [CANDIDATE 2: CRC-16 — CONFIDENCE: REGEX-MATCH]
│   ├── Hashcat Mode: --
│   └── John Format: --
│     
└── [CANDIDATE 3: FCS-16 — CONFIDENCE: REGEX-MATCH]
    ├── Hashcat Mode: --
    └── John Format: --
      


[HASH CLUSTER 2]
├── [CANDIDATE 1: FCS-16 — CONFIDENCE: HIGH]
│   ├── Hashcat Mode: --
│   └── John Format: --
│     
├── [CANDIDATE 2: CRC-16-CCITT — CONFIDENCE: MEDIUM-LOW]
│   ├── Hashcat Mode: --
│   └── John Format: --
│     
└── [CANDIDATE 3: CRC-16 — CONFIDENCE: REGEX-MATCH]
    ├── Hashcat Mode: --
    └── John Format: --
      


[HASH CLUSTER 3]
└── [CANDIDATE 1: CRC-24 — CONFIDENCE: REGEX-MATCH]
    ├── Hashcat Mode: --
    └── John Format: --
      


[HASH CLUSTER 4]
├── [CANDIDATE 1: DES(Unix) — CONFIDENCE: REGEX-MATCH]
│   ├── Hashcat Mode: 1500
│   └── John Format: descrypt
│     
└── [CANDIDATE 2: DEScrypt — CONFIDENCE: REGEX-MATCH]
    ├── Hashcat Mode: 1500
    └── John Format: descrypt
      


[HASH CLUSTER 5]
├── [CANDIDATE 1: MD5 — CONFIDENCE: HIGH]
│   ├── Hashcat Mode: 0
│   └── John Format: raw-md5
│     
├── [CANDIDATE 2: MD4 — CONFIDENCE: MEDIUM-LOW]
│   ├── Hashcat Mode: 900
│   └── John Format: raw-md4
│     
├── [CANDIDATE 3: NTLM — CONFIDENCE: MEDIUM-LOW]
│   ├── Hashcat Mode: 1000
│   └── John Format: nt
│     
├── [CANDIDATE 4: LM — CONFIDENCE: REGEX-MATCH]
│   ├── Hashcat Mode: 3000
│   └── John Format: lm
│     
├── [CANDIDATE 5: Double MD5 — CONFIDENCE: REGEX-MATCH]
│   ├── Hashcat Mode: 2600
│   └── John Format: --
│     
├── [CANDIDATE 6: MD2 — CONFIDENCE: REGEX-MATCH]
│   ├── Hashcat Mode: --
│   └── John Format: md2
│     
├── [CANDIDATE 7: RIPEMD-128 — CONFIDENCE: REGEX-MATCH]
│   ├── Hashcat Mode: --
│   └── John Format: ripemd-128
│     
├── [CANDIDATE 8: Haval-128 — CONFIDENCE: REGEX-MATCH]
│   ├── Hashcat Mode: --
│   └── John Format: haval-128-4
│     
├── [CANDIDATE 9: SNEFRU-128 — CONFIDENCE: REGEX-MATCH]
│   ├── Hashcat Mode: --
│   └── John Format: snefru-128
│     
└── [CANDIDATE 10: Tiger-128 — CONFIDENCE: REGEX-MATCH]
    ├── Hashcat Mode: --
    └── John Format: --
      


[HASH CLUSTER 6]
├── [CANDIDATE 1: NTLM — CONFIDENCE: HIGH]
│   ├── Hashcat Mode: 1000
│   └── John Format: nt
│     
├── [CANDIDATE 2: MD5 — CONFIDENCE: MEDIUM-HIGH]
│   ├── Hashcat Mode: 0
│   └── John Format: raw-md5
│     
├── [CANDIDATE 3: MD4 — CONFIDENCE: MEDIUM-LOW]
│   ├── Hashcat Mode: 900
│   └── John Format: raw-md4
│     
├── [CANDIDATE 4: LM — CONFIDENCE: REGEX-MATCH]
│   ├── Hashcat Mode: 3000
│   └── John Format: lm
│     
├── [CANDIDATE 5: Double MD5 — CONFIDENCE: REGEX-MATCH]
│   ├── Hashcat Mode: 2600
│   └── John Format: --
│     
├── [CANDIDATE 6: MD2 — CONFIDENCE: REGEX-MATCH]
│   ├── Hashcat Mode: --
│   └── John Format: md2
│     
├── [CANDIDATE 7: RIPEMD-128 — CONFIDENCE: REGEX-MATCH]
│   ├── Hashcat Mode: --
│   └── John Format: ripemd-128
│     
├── [CANDIDATE 8: Haval-128 — CONFIDENCE: REGEX-MATCH]
│   ├── Hashcat Mode: --
│   └── John Format: haval-128-4
│     
├── [CANDIDATE 9: SNEFRU-128 — CONFIDENCE: REGEX-MATCH]
│   ├── Hashcat Mode: --
│   └── John Format: snefru-128
│     
└── [CANDIDATE 10: Tiger-128 — CONFIDENCE: REGEX-MATCH]
    ├── Hashcat Mode: --
    └── John Format: --
      


[HASH CLUSTER 7]
├── [CANDIDATE 1: SHA-1 — CONFIDENCE: HIGH]
│   ├── Hashcat Mode: 100
│   └── John Format: raw-sha1
│     
├── [CANDIDATE 2: RIPEMD-160 — CONFIDENCE: REGEX-MATCH]
│   ├── Hashcat Mode: 6000
│   └── John Format: ripemd-160
│     
├── [CANDIDATE 3: Haval-160 — CONFIDENCE: REGEX-MATCH]
│   ├── Hashcat Mode: --
│   └── John Format: --
│     
└── [CANDIDATE 4: Tiger-160 — CONFIDENCE: REGEX-MATCH]
    ├── Hashcat Mode: --
    └── John Format: --
      

```

## Installation
```bash
git clone https://github.com/jobotow/heitt
```

## NOTE
**This project is still under development**

