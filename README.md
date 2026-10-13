# Pigeon Sky

Draw a pigeon and watch it fly with everyone else's across a cloudy sky.

- Tap **in front of** a pigeon to spook it. It turns and flies the other way.
- Tap **on** a pigeon to see who drew it.
- Artists can remove their own pigeons from the same browser they drew them in.

It's a static site (plain HTML, no build step) that stores pigeons in a free [Supabase](https://supabase.com) database.

## Files

| File | What it is |
| --- | --- |
| `index.html` | The whole site |
| `config.js` | Your Supabase URL and public key |
| `supabase.sql` | Creates the database table and its safety rules |

## Setup

### 1. Create the database (about 5 minutes)

1. Sign up at supabase.com and create a new project (the free plan is fine).
2. Open **SQL Editor**, paste in all of `supabase.sql`, and click **Run**.
3. Open **Project Settings → API** and copy the **Project URL** and the **anon public** key.

### 2. Add your keys

Open `config.js` and paste them in:

```js
window.PIGEON_CONFIG = {
  supabaseUrl: "https://YOUR-PROJECT.supabase.co",
  supabaseAnonKey: "YOUR-ANON-KEY"
};
```

The anon key is designed to be public. The rules in `supabase.sql` only let visitors read pigeons and add new ones.

### 3. Publish on GitHub Pages

1. Push these files to the root of a GitHub repository.
2. Go to **Settings → Pages**, set **Source** to "Deploy from a branch", and pick `main` and `/ (root)`.
3. After a minute the site is live at `https://YOUR-USERNAME.github.io/REPO-NAME/`.

For a custom domain, add it under **Settings → Pages → Custom domain**.

### Or publish on Netlify

1. Sign in at netlify.com and choose **Add new site → Import an existing project**.
2. Connect GitHub and pick this repo. Leave the build command empty and set the publish directory to `/`.
3. Click **Deploy**. Rename the site under **Site configuration → Change site name**, or add your own domain under **Domain management**.

You can also skip GitHub: drag the unzipped folder onto app.netlify.com/drop.

## Moderating

To remove any pigeon, open Supabase → **Table Editor → pigeons** and delete the row.

## Notes

- With empty keys in `config.js`, the site runs as a local preview. Pigeons you draw then stay on your own screen.
- New pigeons from other people appear within about 20 seconds.
- The sky shows the 200 most recent pigeons.
