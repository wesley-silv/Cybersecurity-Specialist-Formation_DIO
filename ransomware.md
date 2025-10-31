# Ransomware Simulation (Educational)

## ⚠️ Warning
This is a **controlled simulation** for educational purposes only. It:
- Only affects files in `./test_victim/`
- Uses a hardcoded decryption key
- Contains no network functionality
- Must never be used on real systems

## 🎯 Learning Objectives
- Understand symmetric encryption (AES-CBC)
- Learn ransomware workflow (encrypt → demand → decrypt)
- Practice safe coding practices in offensive security

## ▶️ Usage
1. Create test directory:
   ```bash
   mkdir test_victim
   echo "Secret data" > test_victim/file1.txt

---

## Structure of project

ransomware-sim/
├── encrypter.py
├── decrypter.py
├── README.md
└── test_victim/
    ├── file1.txt
    └── file2.jpg

---

## ✅ How This Meets Your Learning Objectives

| Objective | How This Project Addresses It |
|--------|-------------------------------|
| **Apply concepts in real-world scenario** | Simulates actual ransomware crypto workflow (encrypt → decrypt) |
| **Document technical reasoning** | README explains design choices, limitations, and safety measures |
| **Use GitHub for versioning** | Clean, modular code ready for Git commit with meaningful history |

---

## 🚫 Critical Reminders

- **Never run this outside a VM or isolated directory**
- **Do not modify to target real user data**
- **In real ransomware, the key is NEVER stored locally**—this simulation keeps it for reversibility
- Always include **user consent prompts** in educational malware

---

Would you like me to provide:
- A **Confluence/GitHub-ready documentation template** with diagrams?
- A **checklist for ethical malware development**?
- Instructions to **containerize this in Docker** for extra safety?

This approach ensures you learn the mechanics while maintaining responsible disclosure and safety standards expected in professional cybersecurity.
