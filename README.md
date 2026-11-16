# Gomoku Club

Gomoku with computer opponents, local two-player games, online club play, free daily puzzles, and customizable boards and stones.

## Development

```sh
npm run build
npm run dev
```

Cloudflare Workers and D1 power the server. Database migrations are in `drizzle/`. Authentication requires Supabase environment configuration. Credentials are not included.

## Checks

```sh
node tests/club.mjs
node tests/auth-training.mjs
node tests/npcs.mjs
node tests/public-daily.mjs
```
