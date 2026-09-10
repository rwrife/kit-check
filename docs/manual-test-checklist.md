# Manual Test Checklist (Release Readiness)

This checklist gates any claim that Kit Check is ready to try outside
development. It has **never been run end-to-end**; every item is unchecked.
A build may only be described as validated when the relevant lines are
checked off with dated evidence (device, OS version, build commit) recorded
in the release notes.

Run each flow against a fresh install and, where noted, against a device
with an existing install.

## 1. First launch

- [ ] App launches to the home screen with no account/login prompt.
- [ ] No permission dialogs appear on launch or first use.
- [ ] Works in airplane mode from first launch onward (no network
      dependency, no error toasts).
- [ ] On-device restart behavior is understood: data persistence across
      restart is a known gap (see `docs/platform-support.md`) — record
      observed behavior honestly.

## 2. Kit and trip flow

- [ ] Create a kit with categories, multiple items, quantities, and notes.
- [ ] Edit and reorder items; verify the template ordering sticks.
- [ ] Start a trip from the kit; verify the trip gets an independent
      snapshot (editing the kit afterwards does not change the trip).
- [ ] Mark items packed; mark one item omitted with an omission note
      (note is required for omissions).
- [ ] End the trip and work the return checklist; return some items,
      leave some unresolved; verify unresolved items are listed clearly.
- [ ] Search history by trip name, item name, and omission-note text;
      verify kit/date/active/completed/unresolved filters.
- [ ] Delete a single trip; verify other trips and kits are untouched.

## 3. Backup, restore, and deletion

- [ ] Export a JSON backup; verify it appears on the clipboard and copies
      to a file the user selects.
- [ ] Restore the same JSON on a device; verify the preview lists the
      records and nothing changes until confirmed; cancelling leaves data
      untouched.
- [ ] Attempt to restore a tampered/invalid backup (wrong schemaVersion,
      duplicate ids); verify it is rejected with no data changes.
- [ ] Export history CSV; verify columns match `docs/backup-and-export.md`
      and text containing commas/quotes is handled.
- [ ] Delete all local data; verify the app returns to first-launch state
      (kits, trips, history all gone; no undo).

## 4. Screen reader (TalkBack on Android, VoiceOver on iOS)

- [ ] Every interactive control announces a meaningful label (not "button"
      alone or raw enum text).
- [ ] Checklist status is conveyed in words (packed/omitted/returned/
      unresolved), not by color alone.
- [ ] Dialog focus starts sensibly; cancel/confirm buttons are reachable
      and announced distinctly.
- [ ] Destructive actions (delete trip, delete all) announce their
      consequences in the confirmation text.

## 5. Dynamic text

- [ ] With the OS font scale raised to the largest setting, core screens
      (home, kit editor, trip checklist, history, backup dialogs) remain
      usable: no clipped button labels and no lost actions.
- [ ] Text does not overlap at the smallest setting either.

## 6. Offline operation

- [ ] Re-run flows 1–3 in airplane mode; results are identical to online.
- [ ] No retries, spinners waiting on network, or "check your connection"
      errors appear anywhere.

## Evidence recording

When a section passes, record in the release notes: date, device model,
OS version, app build (commit + version), and who ran it. Any failure gets
a follow-up issue with reproduction steps, and the affected section stays
unchecked.
