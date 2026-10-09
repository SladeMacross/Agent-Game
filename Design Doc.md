# Agent Game: Design Doc

**Created by:** David Anthony Martinez
**Original notes:** `Projects\Video Games\agent.txt` (project start 11/02/2017)
**Doc started:** 10/07/2026

---

## Core idea
A **think-before-you-act** game. The Agent scans, plans, then executes. Information matters more than reflexes, and combat is fast and lethal on both sides.

This game split off from the action "megametroidvania" concept. That game is about power growth and beat-'em-up action, and this one is about stealth and tactics.

---

## World (from the 2017 notes)
High-tech near future:
- Advanced AI, cloud computing
- Drones, robots, surrogates (self-driving or flying)
- Androids, exo-suits
- Smart objects and devices
  - **Privacy bubble**: sensor and detector blockers, anti-recognition tech
  - Wearable tech: watches and wristbands, fashionable tech jewelry
  - Internet glasses or contacts (microscope, binocular, telescope; **full EM spectrum**)
  - Advanced sensors
- Personal networks and satellite uplinks
- Flexible surface screens (walls, counters, doors)
- **"WiFi" see-through-wall**
- AR/VR, BCI devices
- Graphene replacing silicon
- Genetic modification and engineering, cloning
- Awake, dream and thought imaging, recording and sharing
- Metamaterials and superconductors
- 3D printing
- Portable diagnostics
- **Human body shop**

---

## The Agent's gear (from the 2017 notes)

**Badge/ID (hand-held)**
- Computer (AI)
- Communicator
- Scanner

**Weapon (hand-held)**
- Directed energy beam or blast (weak to strong)
- Energy shield or disruptor
- Self-destruct

**Surface vehicle**
- AI, communicator, scanner
- Torpedoes, mines, missiles, rockets
- Energy beam, shield or disruptor
- Self-destruct, stealth

**Drone**
- AI, communicator, scanner
- Energy beam, shield or disruptor
- Self-destruct, stealth

---

## Mechanics ideas (from brainstorming)

### Shared modules = upgrade system
Every device is built from the same modules: **AI, communicator, scanner, beam, shield or disruptor, self-destruct, stealth**.
- Option A: upgrade a module once and it improves on every device that has it
- Option B: a separate tree per device, so the player chooses where to invest

### Gear → gameplay
| Gear | Gameplay role |
|---|---|
| Scanner | Reveals enemies, weak points, hidden paths, armor types |
| Energy beam (weak to strong) | Quick shot vs. a charged shot (trade-off: noise and time) |
| Shield or disruptor | Block, or a pulse that disables tech and armor |
| Self-destruct | Last-resort overload; drone kamikaze; destroying evidence |
| Drone | Scouting ahead, distractions, remote actions |
| Vehicle | Insertion and extraction, chase sequences, mobile base |
| Badge AI | Mission guide, intel, hacking |

### World tech → mechanics
- **Privacy bubble:** the Agent hides from sensors, *or* enemies hide from your scanner
- **See-through-wall WiFi:** scan through walls to plan routes
- **EM-spectrum glasses:** vision modes (thermal, wiring, cameras, etc.)
- **Exo-suits and androids:** tougher enemy types
- **Human body shop:** where you get cyberware and body upgrades

### Possible carry-over: armor tiers
Weak, medium and heavy enemies. Each tier needs a different tool, and the scanner tells you which is which before you commit. This turns a fight into a planning puzzle.

### Combat feel
- Low health on both sides, so a few hits kill anyone
- Going in loud is possible but risky, and stealth rewards smart play
- Upgrades expand **options** (new tools, more scanning, better stealth) more than raw stats

### Inspirations
*Mark of the Ninja*, *Katana Zero*, *Hotline Miami*, *Dishonored*, *Invisible Inc.*, *Deus Ex*

---

## Visual style & perspective
**2D pixel art.** Perspective changes by area type:
- **Top-down:** open, horizontal, social spaces such as markets, streets, plazas and hubs. Good for crowds, blending in, and tailing targets.
- **Side view (cross-section):** vertical spaces such as building infiltration, towers, vents, elevator shafts and multi-floor layouts.
- The scanner, EM vision and see-through-wall work in both views.

Precedents for mixing perspectives: *Zelda II*, *Blaster Master*, *Contra*'s tunnel stages. Side-view stealth references: *Gunpoint* (rewiring building electronics, a strong fit for EM vision and hacking), *Mark of the Ninja*, *Elevator Action*.

---

### Game types (from `Video Game Ideas\game types.txt`)
Of the 2D types on that list, the Agent Game uses:
- **Horizontal platformer** for the side-view infiltration missions
- **Top-down action RPG / top-down shooter** for the hubs and streets

---

## Engine: Godot 4.7
Decided 10/08/2026. The editor is at `C:\Program Files (x86)\Godot\Godot_v4.7.2-stable_win64.exe`.

Pixel-art setup: a 480×270 game screen, scaled up by whole numbers (3× = 1440×810 window) with sharp, unblurred pixels.

### Prototype 1: side-view test room
A single room with box placeholder art, used to test how stealth feels:
- The Agent moves and jumps
- A guard patrols with a visible vision cone; walls and floors block its sight
- Being seen = restart. Reaching the green exit = mission complete
- **Hold Q to scan:** time slows to 30% and guards show their armor tier. This tests the "real-time with a scan mode" option from open decision 2.

Controls: A/D or arrows to move, Space/W to jump, hold Q to scan, R to restart.

---

## Open decisions
1. ~~**Perspective**~~: 2D pixel art, mixed (see above). Still to decide: which view handles the main missions?
2. **Real-time or turn-based** planning?
3. **Structure:** mission select, or a connected world?
4. **Story:** who the Agent works for, and why. Undecided.
5. **Title:** undecided.
