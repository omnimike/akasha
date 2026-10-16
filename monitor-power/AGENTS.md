# monitor-power

Arch package that sleeps and then powers down the monitor after inactivity in multi-user mode. The system itself is never suspended or powered off.

## Structure

- `PKGBUILD` — Arch package definition
- `Makefile` — thin wrapper around `makepkg`
- `monitor-power.target` — systemd target that toggles monitor power saving (`Wants=`/`After=` on the service), pulled in by `multi-user.target` when enabled. Disabled by default, so nothing changes at boot until it is enabled
- `monitor-power.service` — oneshot systemd service (with `RemainAfterExit=`) that programs kernel console blanking on `/dev/tty1` via `setterm`; its `ExecStop=` disables blanking/powerdown and pokes (unblanks) the console, so stopping the target wakes the monitor
- `monitor-power.install` — pacman hooks: `daemon-reload` on install/upgrade, cleanup on remove

## How it runs

Navigate to `monitor-power/` and run `make install`. Power saving does not start at boot by default — enable it with:

```bash
sudo systemctl enable --now monitor-power.target
sudo systemctl disable --now monitor-power.target   # also wakes the monitor
```

## Key details

- Timing is idle-based, using the kernel virtual-console blanking timers: after 1 minute without console activity the screen blanks (monitor sleep), and after a further 4 minutes blanked/suspended the monitor enters VESA powerdown — 5 minutes idle in total. Console (keyboard) activity resets both clocks and wakes the monitor; SSH activity does not count as console activity
- The `--powerdown` value is an interval after blanking, not from idle, hence `4` and not `5` in `monitor-power.service`
- Only the monitor is affected: no unit in this package suspends, hibernates or powers off the system
- Assumes a framebuffer virtual console on `/dev/tty1` (the normal multi-user console); it does nothing in a graphical session
