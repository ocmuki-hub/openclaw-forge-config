const http = require('http');
const { execSync } = require('child_process');

const PORT = 3000;
const TELEGRAM_CHAT_ID = '8274533218';

const server = http.createServer((req, res) => {
  if (req.method === 'POST') {
    let body = '';
    
    req.on('data', chunk => body += chunk);
    req.on('end', () => {
      try {
        const data = JSON.parse(body);
        const event = req.headers['x-github-event'];
        
        console.log(`Received GitHub event: ${event}`);
        
        if (event === 'push') {
          const repo = data.repository?.full_name || 'unknown';
          const branch = (data.ref || '').replace('refs/heads/', '');
          const author = data.pusher?.name || data.sender?.login || 'unknown';
          const commits = data.commits?.length || 0;
          const commitMsg = data.head_commit?.message?.split('\n')[0] || '';
          const commitSha = data.head_commit?.id?.slice(0, 7) || '';
          
          const message = `🦞 GitHub Push

Repo: ${repo}
Branch: ${branch}
Author: ${author}
Commit: ${commitSha}
Message: ${commitMsg}
Commits: ${commits}

https://github.com/${repo}/commit/${data.head_commit?.id}`;
          
          try {
            execSync(`openclaw message send --channel telegram --target ${TELEGRAM_CHAT_ID} --message "${message}"`, { encoding: 'utf8' });
            console.log(`Sent to Telegram: ${repo}/${branch}`);
          } catch (e) {
            console.error('Telegram send failed:', e.message);
          }
        } else if (event === 'pull_request') {
          const repo = data.repository?.full_name || 'unknown';
          const action = data.action || 'unknown';
          const prNumber = data.number || 'unknown';
          const prTitle = data.pull_request?.title || 'unknown';
          const author = data.sender?.login || 'unknown';
          
          const message = `🦞 GitHub PR ${action}

Repo: ${repo}
PR #${prNumber}: ${prTitle}
By: ${author}

https://github.com/${repo}/pull/${prNumber}`;
          
          try {
            execSync(`openclaw message send --channel telegram --target ${TELEGRAM_CHAT_ID} --message "${message}"`, { encoding: 'utf8' });
            console.log(`Sent to Telegram: PR #${prNumber} ${action}`);
          } catch (e) {
            console.error('Telegram send failed:', e.message);
          }
        }
        
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('OK');
      } catch (e) {
        console.error('Parse error:', e.message);
        res.writeHead(400);
        res.end('Bad Request');
      }
    });
  } else {
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('GitHub Webhook Handler - OK');
  }
});

server.listen(PORT, () => {
  console.log(`GitHub webhook handler running on port ${PORT}`);
  console.log(`Forwarding push/PR events to Telegram chat ${TELEGRAM_CHAT_ID}`);
});