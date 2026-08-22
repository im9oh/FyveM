# Economy balance

Design target: **serious economy RP, no money wipe, ever.**

Because there is no reset, the only thing keeping this economy alive is that
money must leave it faster than it enters — permanently, and at every wealth
level. Everything below is built around that one constraint.

Files:

- `faucets.csv` — every income source, hourly value, AFK risk
- `sinks.csv` — every money drain
- `vehicles.csv` — the car ladder
- `robberies.csv` — heist list (payouts NOT yet set)

---

## The anchor

**Entry legal job = $1,200/hour net.** Every other number is derived from it.

Session length assumed 2–8 hours. A casual regular plays ~10 h/week, a
committed player 40+.

---

## The car ladder

The important decision: **vanilla GTA cars are transport, modded cars are the
goal.**

| Tier | Where | Price | Feel |
| --- | --- | --- | --- |
| Beater | PDM | $8k–20k | Week one. It runs. |
| Daily | PDM | $25k–60k | The honest worker's car. |
| Good vanilla | PDM | $80k–150k | Fast and fun. |
| Vanilla top | PDM | $200k–300k | "I'm doing fine." |
| **Modded A** | Import | **$400k–700k** | **The first real dream. R34, Supra, E46 M3.** |
| Modded B | Import | $900k–1.8M | Serious money. GT-R, RS6, C63. |
| Modded C | Import | $2.5M–5M | Countable on two hands, server-wide. |
| Modded D | — | not for sale | Won or built. Never purchasable. |

**Vanilla supercars are capped at $300k on purpose.** If a T20 costs $1M it
becomes aspirational whether you want it to or not — price is what tells a
player what to want. Keeping the whole vanilla catalogue below the cheapest
modded car is what makes PDM feel like a stepping stone instead of a
destination.

### Making modded cars behave differently

Price alone is not enough. Three mechanics do the real work:

1. **Limited stock.** The import dealer receives a fixed number of units per
   week, server-wide, on a rotating catalogue. Money cannot always be
   converted into a car — so it sits, and upkeep eats it. This is the single
   strongest anti-inflation lever available.
2. **Upkeep scales with value.** Insurance is 1.5% of value weekly and a major
   repair is 12–18%. A $3M car costs $45,000/week to own and $540,000 to crash
   badly. That drain never stops and never needs a wipe.
3. **Parts come from players.** Modded repairs need imported parts a mechanic
   player has to source. The car becomes a relationship, not a purchase.

---

## The drain curve

This is the actual design. What percentage of a player's income should
disappear into sinks, by wealth level:

| Wealth level | Target drain | Effect |
| --- | --- | --- |
| New (week 1–4) | 40–50% | Progress feels fast. They keep playing. |
| Established (month 2–6) | 65–75% | Progress slows. Choices start mattering. |
| Wealthy (month 6–14) | 85–95% | Net worth nearly plateaus. |
| Top end | **over 100%** | Must keep working or sell. Nobody retires. |

The curve is achieved by making the big sinks a **percentage of what you own**
rather than a flat fee. Flat fees stop mattering to rich players; percentages
never do.

### Worked example — new player, 10 h/week

| | |
| --- | --- |
| Income (10h @ $1,200) | +$12,000 |
| Apartment rent | −$3,000 |
| Insurance (1 beater @ $12k) | −$180 |
| Garage | −$500 |
| Fuel | −$400 |
| Medical / incidentals | −$1,000 |
| **Net** | **+$6,920 (42% drained)** |

Buys their first PDM beater around day 5.

### Worked example — established, 15 h/week, 3 cars (~$400k), house

| | |
| --- | --- |
| Income (15h @ $2,200) | +$33,000 |
| House tax | −$10,000 |
| Insurance (1.5% of $400k) | −$6,000 |
| Garage (3 cars) | −$1,500 |
| Fuel | −$1,200 |
| Repairs | −$3,000 |
| Medical / ammo | −$1,400 |
| **Net** | **+$9,900 (70% drained)** |

Saving for their first modded car. At this rate it takes months — which is the
point.

### Worked example — wealthy, 25 h/week, $3M of cars, mansion, a business

| | |
| --- | --- |
| Income (25h @ $3,500 + business) | +$107,500 |
| Mansion tax | −$35,000 |
| Insurance (1.5% of $3M) | −$45,000 |
| Garage (8 cars) | −$4,000 |
| Fuel | −$3,000 |
| Repairs (modded parts, 18%) | −$12,000 |
| Business wages | −$15,000 |
| **Net** | **−$6,500 (over 100% drained)** |

**They are losing money.** They must work more hours, sell a car, or shed a
property. This is the anti-inflation engine, and it runs forever without a
wipe.

---

## AFK payout risks

Ranked. Anything paying a player for being connected rather than for doing
something is a permanent leak in a no-wipe economy.

| Risk | Source | Fix |
| --- | --- | --- |
| **CRITICAL** | Police / EMS timer salary | Pay per completed call, report or arrest — never per minute connected. |
| **CRITICAL** | Any payout on a repeating server timer | Delete the pattern entirely. |
| **HIGH** | Drug production / crafting timers | Must require active tending. No offline or idle accrual. |
| **HIGH** | Fishing, mining, farming | Single repeated keypress = macro. Needs input variance and per-hour diminishing returns. |
| **HIGH** | Bus route | Fixed repeating path is trivially automated. Randomise stops or cut the job. |
| **MEDIUM** | Delivery / trucking | Require manual interaction at each stop, not just arrival. |
| **MEDIUM** | Passive business sales | Cap it, and require staff online. |
| **MEDIUM** | Drug sales in a zone | Never pay for standing somewhere. Require a transaction. |

**General rule:** pay on *completion of a varied action*, never on a tick. Add
a daily earnings cap per job so a 14-hour session cannot out-earn common sense.

---

## No-wipe specific risks

With no reset, every wrongly-created dollar is permanent.

1. **Dupe bugs matter more than payout tuning.** One shop that pays twice,
   running for a weekend, does more damage than a year of slightly generous
   jobs. See the security rules in `CLAUDE.md`.
2. **Admin-spawned money must be logged**, every single instance, from day one,
   with who, how much and why. Untracked admin money is the most common cause
   of death for a server economy.
3. **Prefer non-cash rewards at the top end.** A weapons shipment that pays in
   guns, or a job that pays in parts, adds value to the world without adding
   currency to it.
4. **Player-to-player transfers should be taxed** (7% on vehicle sales). Money
   changing hands is an opportunity to remove some.

---

## Open decisions

- Robbery payouts — see `robberies.csv`, not yet set.
- Whether modded cars can ever be bought with real money. If they can, none of
  the above matters.
