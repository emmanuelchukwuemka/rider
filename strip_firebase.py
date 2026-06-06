import os
import re

def process_dart_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Replace firestore imports
    new_content = re.sub(r"import\s+'package:cloud_firestore/cloud_firestore\.dart';", "import '/backend/schema/util/mock_firestore.dart';", content)
    # Replace firebase auth imports
    new_content = re.sub(r"import\s+'package:firebase_auth/firebase_auth\.dart';", "import '/auth/mock_firebase_auth.dart';", new_content)
    # Replace firebase core
    new_content = re.sub(r"import\s+'package:firebase_core/firebase_core\.dart';", "import '/auth/mock_firebase_auth.dart';", new_content)

    if new_content != content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Updated {filepath}")

def main():
    # 1. Update pubspec.yaml
    pubspec_path = 'pubspec.yaml'
    with open(pubspec_path, 'r', encoding='utf-8') as f:
        pubspec = f.read()
    
    pubspec = re.sub(r'\s*cloud_firestore:.*?\n', '\n', pubspec)
    pubspec = re.sub(r'\s*cloud_firestore_platform_interface:.*?\n', '\n', pubspec)
    pubspec = re.sub(r'\s*cloud_firestore_web:.*?\n', '\n', pubspec)
    pubspec = re.sub(r'\s*firebase_auth:.*?\n', '\n', pubspec)
    pubspec = re.sub(r'\s*firebase_auth_platform_interface:.*?\n', '\n', pubspec)
    pubspec = re.sub(r'\s*firebase_auth_web:.*?\n', '\n', pubspec)
    pubspec = re.sub(r'\s*firebase_core:.*?\n', '\n', pubspec)
    pubspec = re.sub(r'\s*firebase_core_platform_interface:.*?\n', '\n', pubspec)
    pubspec = re.sub(r'\s*firebase_core_web:.*?\n', '\n', pubspec)
    pubspec = re.sub(r'\s*firebase_performance:.*?\n', '\n', pubspec)
    pubspec = re.sub(r'\s*firebase_performance_platform_interface:.*?\n', '\n', pubspec)
    pubspec = re.sub(r'\s*firebase_performance_web:.*?\n', '\n', pubspec)
    
    with open(pubspec_path, 'w', encoding='utf-8') as f:
        f.write(pubspec)
    print("Updated pubspec.yaml")

    # 2. Process all dart files
    for root, dirs, files in os.walk('lib'):
        for file in files:
            if file.endswith('.dart'):
                process_dart_file(os.path.join(root, file))
                
    print("Done stripping Firebase.")

if __name__ == "__main__":
    main()
