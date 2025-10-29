# Detection and Defense — Practical Notes

## Quick visual checks
- Look at the domain in the browser address bar. Real domains are exact (no typos).
- Check for HTTPS padlock. A padlock is necessary but not sufficient (attacker can have TLS).
- Hover links to see the real target (do not click).
- Small misspellings in logo, layout or text may indicate fraud.

## Email checks
- Inspect full email headers to see where the message actually came from.
- Verify SPF/DKIM/DMARC results if possible.
- Be skeptical of urgent language and links that ask to re-enter credentials.

## Browser signals
- Password managers typically fill only on real sites for saved credentials. Missing autofill can be a sign.
- Certificate details can show the organization. Click the padlock ➜ Certificate to inspect issuer.

## Technical defenses
- Use multi-factor authentication (MFA) so stolen passwords alone are not enough.
- Use browser extensions that block known phishing sites.
- Keep browsers and OS patched.

## Fast detection checklist (for reports)
1. Domain and URL look suspicious? (typo, extra subdomain)
2. Email header origin matches sender? (SPF/DKIM)
3. Padlock shows correct organization? (check certificate)
4. Unexpected login request? (contact service by official channel)
5. Use MFA and change password from trusted device if needed.

## Notes for defenders
- Train users with safe simulated exercises using consent and isolated labs only.
- Maintain an internal reporting channel for suspected phishing.
