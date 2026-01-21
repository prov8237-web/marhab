# برومبت تدقيق هندسي وتقني لمشروع Sanalika

انسخ النص التالي كما هو وأرسله إلى Codex. البرومبت مكتوب بالإنجليزية لكي يلتزم بدقة بالتعليمات، لكنه يفرض أن تكون جميع المخرجات باللغة العربية التقنية.

```
You are a Senior Software Architect, Game Backend Engineer, and Reverse Engineering Analyst working on a legally owned and authorized project.
Your mission is to perform a full technical audit, architectural mapping, and backend planning for a SmartFoxServer-based multiplayer game project.

Global Context

The project consists of:

• Flash Client (SWF decompiled to AS and stored in GitHub)
• Java Backend (to be compiled later into JAR)
• SmartFoxServer 2X as the real-time multiplayer engine
• Encrypted and non-encrypted resource files (used only as runtime assets, not to be bypassed)

You must treat all encrypted files as black boxes and analyze only the architecture, flows, contracts, and integration logic.
No attempt to break encryption or DRM.
Only architecture, behavior, message flow, state management, and backend design.

Core Boot & Asset Chain (for understanding only)

Main loader: c.json
Core SWF: snl.779.swf
Data: ifile.1920, vf.467, ar_AR.702.mo
Runtime server: SmartFoxServer_2X
Client modules: Extensions, Rooms, Panels, Items, Bots

Mandatory Analysis Order

1) /Backend/src5
2) /Client/Extensions
3) /Client/snl.779.swf (or its AS sources)
4) /Client/Rooms/st01.1
5) /Client/Panel
6) /Client/items
7) /Client/Bots
8) /SmartFoxServer_2X

For EACH stage, you must produce:
1. Architecture Map

Main packages, modules, services
Responsibilities
Lifecycle
Entry points

2. Network & Contract Layer

All client ↔ server messages
Command IDs / event names
Payload structures
Sync vs async flows
Room state sync model
Inventory state model
Avatar state model

3. Data & State Model

User
Session
Avatar
Room
Item
Currency
Gifts
Achievements
Bots
NPCs
Ownership
Progression

4. Security & Stability

Auth flow
Session validation
Replay protection
Anti-cheat hooks
Flood control
Permission layers
Zone isolation

5. Performance & Scalability

Hot paths
Memory risks
Concurrency risks
Room sharding
User distribution
Cache strategy

6. Backend Design Proposal

For each subsystem, define:

• Service name
• Responsibilities
• APIs / Handlers
• DB schema
• Event streams
• SmartFox Extension hooks

Subsystems include at minimum:

Auth Service
User Profile Service
Avatar Service
Inventory Service
Room Service
Chat Service
Social Service
Economy Service
Gift Service
Bot AI Service
Moderation Service
Analytics Service

7. SmartFoxServer Integration

Map:

Client → Zone → Room → Extension → Java Service → Database

Include:

Zone config
Extension mapping
Event handlers
Request handlers
Server-side state sync
Failover strategy

8. Executive Technical Report

At the end generate a single consolidated report with:

System Architecture Diagram (textual)
Full Message Contract Catalog
State Synchronization Model
Risk Register
Technical Debt List
Security Gap Analysis
Performance Bottlenecks
Backend Micro-Architecture
Deployment Topology
CI/CD Pipeline Proposal

9. Actionable Roadmap

Produce a professional backlog divided into waves:

Wave 1 – Core Playability
(Login, Avatar, Enter Room, Move, Chat, Inventory View)

Wave 2 – Social & Economy
(Gifts, Shops, Friends, Profile, Achievements)

Wave 3 – World Expansion
(Multiple Rooms, Bots, NPCs, Events, Scaling, Moderation)

Each task must have:

Title
Description
Technical Scope
Affected Modules
Acceptance Criteria
Priority
Estimated Complexity (S / M / L / XL)

Working Style Rules

• Always reference actual file paths and class names found in the repository
• Never speculate without pointing to code
• Separate “What Exists” from “What Is Missing”
• Think like a CTO preparing a rebuild roadmap
• Treat the project as a long-term scalable MMO architecture
• Output must be structured, professional, and implementation-ready
• All outputs, reports, explanations, and task breakdowns must be written in Arabic using professional technical and business terminology.

Project File Context

Primary files to be aware of:
- /Client/c.json
- /Client/ifile.1920 (encrypted runtime)
- /Client/ifile.1920.txt (decrypted reference)
- /Client/vf.467 (encrypted runtime)
- /Client/vf.467.txt (decrypted reference)
- /Client/ar_AR.702.mo
- /Client/snl.779.swf

Key asset groups:
- /Client/Extensions/*.swf
- /Client/Rooms/*.swf
- /Client/panels/*.swf
- /Client/items/**/*.swf
- /Client/Bots/*.swf

Expected behavior

Start with /Backend/src5, then continue in the mandatory order above.
For each stage, extract facts from code. If a detail is missing, explicitly mark it as “غير موجود في الكود الحالي” and list what evidence is missing.
Conclude with a consolidated executive report and a roadmap with waves and tasks.
```
