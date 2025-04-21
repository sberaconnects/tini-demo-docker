# README.md
# 🧪 Tini vs Zombie Processes Demo

This project demonstrates how [`Tini`](https://github.com/krallin/tini) helps manage zombie processes in Docker containers.

## 🧠 Why Tini?
In Docker containers, the main process becomes PID 1. Most application runtimes (like bash, Node.js, Python) don’t behave like a real init system — they don’t handle `SIGCHLD` or `wait()` on zombie child processes.

`Tini` is a small init system designed to solve this. It:
- Forwards signals correctly
- Reaps orphaned and zombie processes
- Ensures clean container shutdown

## 💡 Demo Design
This project uses a minimal C program to:
- Fork multiple child processes
- Immediately exit those children
- Avoid reaping them from the parent

This reliably creates zombie processes that would accumulate **unless** reaped by a proper init like Tini.

## 🏗️ Build, Run, and Analyze
```bash
chmod +x run_demo.sh
./run_demo.sh
```

This will:
- Stop and remove any existing containers
- Build containers (with and without Tini)
- Run a C-based process that forks children and leaves them unreaped
- Capture running processes and zombie (`Z`) states
- Save results to `results.txt`
- Stop and remove containers afterward

## 🔍 Sample Output (from `results.txt`)
```
\n===== WITH TINI =====
    PID    PPID STAT CMD
      1       0 Ss   /usr/bin/tini -- /zombie
      7       1 S    /zombie
      8       7 Z    [zombie] <defunct>
      9       7 Z    [zombie] <defunct>
     10       7 Z    [zombie] <defunct>
     11       7 Z    [zombie] <defunct>
     12       7 Z    [zombie] <defunct>
     13       7 Z    [zombie] <defunct>
     14       7 Z    [zombie] <defunct>
     15       7 Z    [zombie] <defunct>
     16       7 Z    [zombie] <defunct>
     17       7 Z    [zombie] <defunct>
     18       0 Rs   ps -eo pid,ppid,stat,cmd
\n===== WITHOUT TINI =====
    PID    PPID STAT CMD
      1       0 Ss   /zombie
      7       1 Z    [zombie] <defunct>
      8       1 Z    [zombie] <defunct>
      9       1 Z    [zombie] <defunct>
     10       1 Z    [zombie] <defunct>
     11       1 Z    [zombie] <defunct>
     12       1 Z    [zombie] <defunct>
     13       1 Z    [zombie] <defunct>
     14       1 Z    [zombie] <defunct>
     15       1 Z    [zombie] <defunct>
     16       1 Z    [zombie] <defunct>
     17       0 Rs   ps -eo pid,ppid,stat,cmd
\n===== ZOMBIES IN WITHOUT-TINI =====
      7       1 Z    [zombie] <defunct>
      8       1 Z    [zombie] <defunct>
      9       1 Z    [zombie] <defunct>
     10       1 Z    [zombie] <defunct>
     11       1 Z    [zombie] <defunct>
     12       1 Z    [zombie] <defunct>
     13       1 Z    [zombie] <defunct>
     14       1 Z    [zombie] <defunct>
     15       1 Z    [zombie] <defunct>
     16       1 Z    [zombie] <defunct>
```

## ✅ Analysis
- In **`WITH TINI`**, zombies exist but are reparented to the real process (`/zombie`) — and would be reaped properly.
- In **`WITHOUT TINI`**, zombies accumulate under **PID 1**, which doesn’t reap them.

This clearly demonstrates that:
> **Tini protects your containers from leaking zombie processes** by acting as a proper init system.

## 📌 Conclusion
Always use `Tini` in long-running or production-grade containers to:
- Prevent zombie accumulation
- Forward signals properly (for graceful shutdown)
- Keep your container process model clean and robust

---

#Docker #Tini #Linux #ZombieProcesses #DevOps #ContainerBestPractices