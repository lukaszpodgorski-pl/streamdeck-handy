import streamDeck, {
  action,
  KeyDownEvent,
  SingletonAction,
} from "@elgato/streamdeck";
import { spawn } from "node:child_process";
import { resolveHandyBinary } from "../handy-binary";

type Settings = {
  handyPath?: string;
};

@action({ UUID: "pl.lukaszpodgorski.handy.cancel-dictation" })
export class CancelDictation extends SingletonAction<Settings> {
  override async onKeyDown(ev: KeyDownEvent<Settings>): Promise<void> {
    const { handyPath } = ev.payload.settings;
    const binary = await resolveHandyBinary(handyPath);

    if (!binary) {
      streamDeck.logger.warn("Handy binary not found");
      await ev.action.showAlert();
      return;
    }

    try {
      spawn(binary, ["--cancel"], {
        detached: true,
        stdio: "ignore",
      }).unref();
      await ev.action.showOk();
    } catch (err) {
      streamDeck.logger.error("Failed to invoke Handy CLI", err);
      await ev.action.showAlert();
    }
  }
}
