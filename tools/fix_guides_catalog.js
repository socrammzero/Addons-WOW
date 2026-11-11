const fs = require('fs');

const fPath = 'src/Journey/BundledContent/Guides/guides.html';
const raw = fs.readFileSync(fPath, 'utf8').replace(/<[^>]+>/g, '').replace(/\s+/g, '');
let decoded = Buffer.from(raw, 'base64').toString('utf8');

// Replace Thendal Village
decoded = decoded.split('"1-6 Thendal Village"').join('"1-6 Aldea Thendal"');

const newB64 = Buffer.from(decoded, 'utf8').toString('base64');
const lines = newB64.match(/.{1,76}/g).join('\r\n');
const html = `<!-- Copyright (c) 2006-2026 TomCat's Gaming, LLC. All Rights Reserved.
     Unauthorized use, reproduction, or distribution is prohibited.
     See license.txt included with this distribution for full terms. -->
<html>
\t<head></head>
\t<body>
\t\t<p>
${lines}
\t\t</p>
\t</body>
</html>\r\n`;

fs.writeFileSync(fPath, html, 'utf8');
console.log('guides.html updated and saved successfully.');
