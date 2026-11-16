# Gomoku Club

Gomoku with computer opponents, local two-player games, online club play, daily puzzles, and customizable boards and stones.

## Development

```sh
npm run build
npm run dev
```

The server uses Cloudflare Workers and D1. Database migrations are in `drizzle/`. Authentication requires Supabase environment configuration; no credentials are included.

## Checks

```sh
node tests/club.mjs
node tests/auth-training.mjs
node tests/npcs.mjs
node tests/public-daily.mjs
```
