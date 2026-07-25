const fetch = require('node-fetch'); // If available, or use native fetch in newer node

async function test() {
  const url = 'https://tvspnzobouqblyspmckp.supabase.co/functions/v1/validate-text';
  const key = 'sb_publishable_956A5JpejLw7P1ErrLodUQ_U9KaDPW0';
  
  // Note: we can't test it directly unless we have a user auth token, 
  // because the edge function checks supabase.auth.getUser()
  console.log("Need auth token to test directly");
}
test();
