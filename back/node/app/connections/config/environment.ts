import dotenv, {DotenvConfigOutput} from 'dotenv';

const result: DotenvConfigOutput = dotenv.config();
if (result.error) {
    console.log(`Dotenv Config Error ${result.error}`);
}

const SESSION_SECRET = process.env.SESSION_SECRET;
const REDIS_HOST = process.env.REDIS_HOST;

export {SESSION_SECRET, REDIS_HOST};