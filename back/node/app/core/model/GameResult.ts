import {PlayerType} from "./PlayerType";

type GameResult = {
    winner: PlayerType | null
    draw: boolean
}

export {GameResult}