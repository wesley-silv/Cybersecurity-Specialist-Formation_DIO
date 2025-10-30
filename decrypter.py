#!/usr/bin/env python3
"""
SAFE RANSOMWARE SIMULATION - DECRYPTER
Reverses encryption using the same fixed key.
"""

import os
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives import padding

# MUST match encrypter.py
KEY = b'YourSafeDemoKey1234567890123456'
IV = b'DemoIV1234567890'

def decrypt_file(file_path):
    try:
        with open(file_path, 'rb') as f:
            encrypted_data = f.read()
        
        # Decrypt
        cipher = Cipher(algorithms.AES(KEY), modes.CBC(IV))
        decryptor = cipher.decryptor()
        padded_data = decryptor.update(encrypted_data) + decryptor.finalize()
        
        # Unpad
        unpadder = padding.PKCS7(128).unpadder()
        data = unpadder.update(padded_data) + unpadder.finalize()
        
        # Save original file
        original_path = file_path.replace('.encrypted', '')
        with open(original_path, 'wb') as f:
            f.write(data)
        
        # Remove encrypted file
        os.remove(file_path)
        print(f"[+] Decrypted: {original_path}")
        
    except Exception as e:
        print(f"[-] Failed to decrypt {file_path}: {e}")

def main():
    print("🔓 SAFE RANSOMWARE SIMULATION - DECRYPTER")
    print("⚠️  This will ONLY affect .encrypted files in ./test_victim/")
    
    victim_dir = "./test_victim"
    if not os.path.exists(victim_dir):
        print(f"Error: {victim_dir} does not exist!")
        return
    
    encrypted_files = [f for f in os.listdir(victim_dir) if f.endswith('.encrypted')]
    if not encrypted_files:
        print("No .encrypted files found!")
        return
    
    for filename in encrypted_files:
        filepath = os.path.join(victim_dir, filename)
        decrypt_file(filepath)
    
    print("\n✅ Decryption complete.")

if __name__ == "__main__":
    main()
