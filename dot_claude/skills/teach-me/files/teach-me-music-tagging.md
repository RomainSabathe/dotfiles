# Prompt: Teach Me How Music File Tagging Works

## Context

I manage a personal music library served by Navidrome (a self-hosted music
server). I recently fixed the metadata on an album of MP3 files using Python's
`mutagen` library — splitting combined "Artist - Title" strings into proper
fields, adding multi-valued `TXXX:ARTISTS` frames for Navidrome's multi-artist
support, and saving with `tags.save(v2_version=4)` to ensure ID3v2.4.

I got the job done, but I realized I'm operating on recipes without
understanding the underlying system. I know there are ID3 tags for MP3 and
Vorbis comments for FLAC, but I don't really understand *why* they're different,
who designs these standards, or how the bytes are actually laid out in the file.

## What I Don't Understand

### 1. How Tags Are Physically Stored in a File

- Where do tags actually live in an MP3 file? At the beginning? The end? Both?
  I've heard of ID3v1 being at the end and ID3v2 at the beginning — why the
  change?
- How does a FLAC file store its Vorbis comments? Is it part of the audio
  stream or separate metadata blocks?
- When I embed album art, where does that image data go? Is it just a binary
  blob inside a tag frame?
- If tags are at the beginning of the file, does modifying them require
  rewriting the entire file? How do tools handle this efficiently?

### 2. The ID3 Standard(s) — Versions and Frames

- Who created ID3? Is it an official standard body (like ISO/IETF) or a
  community/industry effort?
- ID3v1 vs ID3v2.3 vs ID3v2.4 — what are the actual differences? Why did v2.3
  stick around so long if v2.4 is better?
- What is a "frame" in ID3? I see codes like `TIT2`, `TPE1`, `TPE2`, `TXXX`,
  `TDRC`. How is the naming scheme organized? What does the T prefix mean?
- `TXXX` seems to be a catch-all for custom tags (I used `TXXX:ARTISTS`). How
  does it differ from the standard frames? Is there a registry of TXXX
  descriptors, or can anyone make up names?
- How does multi-value work in ID3v2.4? I've read about null-byte separators
  for text frames. Does `TPE1` with `["Alice", "Bob"]` store it as
  `Alice\x00Bob`? Does ID3v2.3 really not support this at all?

### 3. Vorbis Comments — Why a Completely Different System?

- Why didn't FLAC/Ogg just adopt ID3? Is it a licensing issue, a technical
  issue, or a philosophical one?
- Vorbis comments seem simpler — just `KEY=value` pairs, repeatable. Who
  defined this format? Is there a spec?
- Are Vorbis comments truly "better" than ID3 for multi-valued fields, or is it
  just different? What are the tradeoffs?
- FLAC uses Vorbis comments but isn't actually Ogg Vorbis — why does it share
  the tagging format?

### 4. Other Tagging Systems

- MP4/M4A files use yet another system (atoms/boxes). Why?
- APE tags — what are they, and why do some MP3 files end up with both ID3 and
  APE tags?
- Is there any effort to unify these, or is fragmentation just accepted?
- When tools like mutagen or TagLib abstract over these formats, where do the
  abstractions leak?

### 5. Who Defines "Standard" Tag Names?

- For ID3, fields like `TPE1` (artist) and `TPE2` (album artist) have official
  definitions. But `TPE2` wasn't originally meant for "album artist" — how did
  that convention emerge?
- For Vorbis comments, is there a canonical list of field names? I see
  `ARTIST`, `ALBUMARTIST`, `ARTISTS` — who decided these? Is `ALBUMARTIST` in
  any spec or is it a de facto convention?
- MusicBrainz seems influential in establishing conventions (like
  `MUSICBRAINZ_TRACKID`). How much of "standard" tagging is actually just
  Picard/MusicBrainz conventions that everyone adopted?

### 6. Tools Ecosystem

- **Desktop/GUI**: I know of MusicBrainz Picard, Mp3tag, Kid3, beets. What are
  the strengths/weaknesses of each? When would I use one over another?
- **Python**: I've used `mutagen`. What are the alternatives? I've seen
  `eyeD3`, `tinytag`, `mediafile`, `pytaglib`. How do they compare — which are
  read-only, which support all formats, which handle multi-valued tags well?
- **C/C++ libraries**: TagLib seems to be the underlying engine for many
  tools. What is its role in the ecosystem?
- When tools say they "support ID3v2.4", does that mean they read it, write it,
  or both? Are there tools that silently downgrade to v2.3?

## How I'd Like You to Teach This

- Start with the **physical layer** — how bytes are laid out in an MP3 file
  vs a FLAC file. Use hex dump examples or ASCII diagrams to show where tags
  sit relative to audio data.
- Build up from there to the **logical layer** — frames, field names,
  encodings, multi-value support.
- Explain the **historical context** — why we ended up with multiple
  incompatible systems rather than one standard. Who were the key players and
  what were their motivations?
- Call out **common misconceptions** explicitly (e.g. "TPE2 was not originally
  meant for Album Artist", "ID3v2.3 is not a subset of ID3v2.4").
- When comparing formats/tools, use **tables** to make differences scannable.
- Relate examples back to **my concrete use case**: MP3 files with ID3v2.4,
  setting `TIT2`, `TPE1`, `TXXX:ARTISTS` via mutagen for Navidrome.
- Provide **decision heuristics** — e.g. "if your library is all FLAC, do X;
  if mixed MP3/FLAC, do Y; if you need maximum compatibility with old devices,
  do Z".

## My Setup for Reference

- Music server: Navidrome (reads ID3, Vorbis comments, MP4 atoms, APE tags)
- Primary format: MP3 (ID3v2.4) and FLAC
- Python tagging library: mutagen (using `mutagen.id3` directly, not `EasyID3`)
- OS: Linux (Arch in distrobox on Fedora 42)
- Tag editor GUI: none currently, open to recommendations
- Library size: ~hundreds of albums, mix of MP3 and FLAC
