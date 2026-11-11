const fs = require('fs');
const path = require('path');

function getAllFiles(dir, filter) {
  let results = [];
  const list = fs.readdirSync(dir);
  list.forEach(file => {
    const full = path.join(dir, file);
    const stat = fs.statSync(full);
    if (stat && stat.isDirectory()) {
      results = results.concat(getAllFiles(full, filter));
    } else if (filter(full)) {
      results.push(full);
    }
  });
  return results;
}

const luaFiles = getAllFiles('src', p => p.endsWith('.lua'));
console.log('Auditing total Lua files in src/:', luaFiles.length);

let bomCount = 0;
let invalidUtf8 = 0;

luaFiles.forEach(file => {
  const buf = fs.readFileSync(file);
  // Check UTF-8 BOM: EF BB BF
  if (buf.length >= 3 && buf[0] === 0xEF && buf[1] === 0xBB && buf[2] === 0xBF) {
    console.error('File has BOM:', file);
    bomCount++;
    // Strip BOM
    const cleanBuf = buf.subarray(3);
    fs.writeFileSync(file, cleanBuf);
    console.log('  -> Stripped BOM from:', file);
  }

  // Validate UTF-8
  try {
    const decoder = new TextDecoder('utf-8', { fatal: true });
    decoder.decode(buf);
  } catch (e) {
    console.error('Invalid UTF-8 encoding in:', file, e.message);
    invalidUtf8++;
  }
});

console.log('BOM check complete. Files with BOM fixed:', bomCount);
console.log('Invalid UTF-8 count:', invalidUtf8);
