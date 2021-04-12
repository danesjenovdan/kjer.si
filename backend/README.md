# KjerSi

To start your Phoenix server, make sure you have `docker` and `docker-compose` installed.

You can then proceed to set everything up by running `docker-compose up`.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## Insert categories
```
INSERT INTO categories (id, name, inserted_at, updated_at) VALUES (gen_random_uuid(), 'testiramo', now(), now());
```