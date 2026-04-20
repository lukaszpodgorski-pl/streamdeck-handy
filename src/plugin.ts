import streamDeck, { LogLevel } from "@elgato/streamdeck";
import { ToggleDictation } from "./actions/toggle-dictation";
import { CancelDictation } from "./actions/cancel-dictation";
import { TogglePostProcess } from "./actions/toggle-post-process";

streamDeck.logger.setLevel(LogLevel.TRACE);

streamDeck.actions.registerAction(new ToggleDictation());
streamDeck.actions.registerAction(new CancelDictation());
streamDeck.actions.registerAction(new TogglePostProcess());

streamDeck.connect();
