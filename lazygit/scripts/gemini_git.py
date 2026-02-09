import json
import os
import subprocess
import sys
import urllib.error
import urllib.request

API_KEY = os.getenv("GEMINI_API_KEY")
API_URL = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key={API_KEY}"


def get_staged_diff():
    try:
        subprocess.check_call(
            ["git", "diff", "--cached", "--quiet"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        return None
    except subprocess.CalledProcessError:
        return subprocess.check_output(["git", "diff", "--cached"], text=True)


def call_gemini(prompt):
    if not API_KEY:
        return "Error: GEMINI_API_KEY not found in environment."

    headers = {"Content-Type": "application/json"}
    data = {"contents": [{"parts": [{"text": prompt}]}]}

    try:
        req = urllib.request.Request(
            API_URL, data=json.dumps(data).encode("utf-8"), headers=headers
        )
        with urllib.request.urlopen(req) as response:
            result = json.load(response)
            try:
                return result["candidates"][0]["content"]["parts"][0]["text"]
            except (KeyError, IndexError):
                return "Error: Could not parse Gemini response."
    except urllib.error.HTTPError as e:
        return f"Error: HTTP {e.code} - {e.reason}"


def generate_commit_message():
    diff = get_staged_diff()
    if not diff:
        return "No staged changes."

    prompt = f"""
Generate a conventional commit message (e.g. 'feat: description') for this diff.
Keep it concise. Main line under 50 chars.
Diff:
{diff}
"""
    return call_gemini(prompt)


def explain_changes():
    if len(sys.argv) > 2:
        filename = sys.argv[2]
        diff = subprocess.check_output(["git", "diff", "HEAD", filename], text=True)
    else:
        diff = get_staged_diff()

    if not diff:
        return "No changes found."

    prompt = f"""
Explain these changes concisely with no more than 30 words max (if possible in bullet points ).
Diff:
{diff}
"""
    return call_gemini(prompt)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: gemini_git.py [commit|explain] [filename]")
        sys.exit(1)

    command = sys.argv[1]

    if command == "commit":
        print(generate_commit_message())
    elif command == "explain":
        print(explain_changes())
