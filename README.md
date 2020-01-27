# nantango

Utopian sample project: Online Quiz Application

## Requirements

[Roswell](https://github.com/roswell/roswell/wiki/Installation)

[Utopian](https://github.com/fukamachi/utopian)

RDBMS(choose one from SQLite3, PostgreSQL, or MySQL)

## Setting up RDBMS

By default, we use SQLite3 during development.  If you use PostgreSQL for RDBMS, please refer to [docs/postgres-setup.md](docs/postgres-setup.md).

## Usage

This app is in the early stages of development. 

Once the app is complete, you can do the following:

|Top Page|Quiz Page|Result Page|
|:---:|:---:|:---:|
|![](https://github.com/t-cool/nantango1/raw/master/img/screenshotA.png)|![](https://github.com/t-cool/nantango1/raw/master/img/screenshotB.png)|![](https://github.com/t-cool/nantango1/raw/master/img/screenshotC.png)|

## Development

To add new features, please refer to [docs/develepment.md](docs/develepment.md).

## Frontend

This project uses React with TypeScript as frontends. The related codes are in frontend directory. You can extended the frontend too.

```bash
$ cd frontend
$ yarn
$ npm run build 
# then, the frontend releted codes will be generated inside `public/assets/quiz-front` folder.
```

## Licence

MIT
