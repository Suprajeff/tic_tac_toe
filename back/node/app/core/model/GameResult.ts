import {PlayerType} from "./PlayerType.js";

type GameResult = {
    winner: PlayerType | null
    draw: boolean
}

export {GameResult}