import { StateFactory } from "../../deps/bw/libs/shared/dist/src/factories/stateFactory";
import { GlobalState } from "../../deps/bw/libs/shared/dist/src/models/domain/globalState";
import { ApiService } from "../../deps/bw/libs/shared/dist/src/services/api.service";
import { AppIdService } from "../../deps/bw/libs/shared/dist/src/services/appId.service";
import { ConsoleLogService } from "../../deps/bw/libs/shared/dist/src/services/consoleLog.service";
import { EnvironmentService } from "../../deps/bw/libs/shared/dist/src/services/environment.service";
import { StateMigrationService } from "../../deps/bw/libs/shared/dist/src/services/stateMigration.service";
import { TokenService } from "../../deps/bw/libs/shared/dist/src/services/token.service";
import { WebCryptoFunctionService } from "../../deps/bw/libs/shared/dist/src/services/webCryptoFunction.service";

import { BrowserCryptoService } from "../../deps/bw/libs/shared/dist/src/services/browserCrypto.service";
import BrowserMessagingService from "../../deps/bw/libs/shared/dist/src/services/browserMessaging.service";
import BrowserMessagingPrivateModeBackgroundService from "../../deps/bw/libs/shared/dist/src/services/browserMessagingPrivateModeBackground.service";
import BrowserPlatformUtilsService from "../../deps/bw/libs/shared/dist/src/services/browserPlatformUtils.service";
import BrowserStorageService from "../../deps/bw/libs/shared/dist/src/services/browserStorage.service";
import I18nService from "../../deps/bw/libs/shared/dist/src/services/i18n.service";
import { StateService } from "../../deps/bw/libs/shared/dist/src/services/state.service";

export function getAPI() {
  return function () {
    const bg = new MainBackground()

    return bg.apiService
  }
}

class MainBackground {
  messagingService; //: MessagingServiceAbstraction;
  storageService; //: StorageServiceAbstraction;
  i18nService; //: I18nServiceAbstraction;
  platformUtilsService; //: PlatformUtilsServiceAbstraction;
  logService; //: LogServiceAbstraction;
  cryptoService; //: CryptoServiceAbstraction;
  cryptoFunctionService; //: CryptoFunctionServiceAbstraction;
  tokenService; //: TokenServiceAbstraction;
  appIdService; //: AppIdServiceAbstraction;
  apiService; //: ApiServiceAbstraction;
  environmentService; //: EnvironmentServiceAbstraction;
  authService; //: AuthServiceAbstraction;
  stateService; //: StateServiceAbstraction;
  stateMigrationService; //: StateMigrationService;


  constructor(isPrivateMode = false) {

    this.messagingService = isPrivateMode
      ? new BrowserMessagingPrivateModeBackgroundService()
      : new BrowserMessagingService();
    this.storageService = new BrowserStorageService();
    this.logService = new ConsoleLogService(false);
    this.stateMigrationService = new StateMigrationService(
      this.storageService,
      this.storageService,
      new StateFactory(GlobalState, Account)
    );
    this.stateService = new StateService(
      this.storageService,
      this.storageService,
      this.logService,
      this.stateMigrationService,
      new StateFactory(GlobalState, Account)
    );
    this.platformUtilsService = new BrowserPlatformUtilsService(
      this.messagingService,
      this.stateService,
      (clipboardValue, clearMs) => {
        if (this.systemService != null) {
          this.systemService.clearClipboard(clipboardValue, clearMs);
        }
      },
      async () => {
        if (this.nativeMessagingBackground != null) {
          const promise = this.nativeMessagingBackground.getResponse();

          try {
            await this.nativeMessagingBackground.send({ command: "biometricUnlock" });
          } catch (e) {
            return Promise.reject(e);
          }

          return promise.then((result) => result.response === "unlocked");
        }
      }
    );
    this.i18nService = new I18nService(BrowserApi.getUILanguage(window));
    this.cryptoFunctionService = new WebCryptoFunctionService(window);
    this.cryptoService = new BrowserCryptoService(
      this.cryptoFunctionService,
      this.platformUtilsService,
      this.logService,
      this.stateService
    );
    this.tokenService = new TokenService(this.stateService);
    this.appIdService = new AppIdService(this.storageService);
    this.environmentService = new EnvironmentService(this.stateService);
    this.apiService = new ApiService(
      this.tokenService,
      this.platformUtilsService,
      this.environmentService,
      this.appIdService,
      (expired) => this.logout(expired)
    );
  }

  async bootstrap() {
    this.containerService.attachToWindow(window);

    await this.stateService.init();

    await (this.i18nService).init();

    return new Promise((resolve) => {
      setTimeout(async () => {
        await this.environmentService.setUrlsFromStorage();
        this.fullSync(true);
        resolve();
      }, 500);
    });
  }

  async logout(expired, userId) {
    await this.eventService.uploadEvents(userId);

    await Promise.all([
      this.cryptoService.clearKeys(userId)
    ]);

    await this.stateService.clean({ userId: userId });
  }
}


class BrowserStorageService {
  storage;

  constructor() {
    this.storage = window.localStorage;
  }

  async get(key) {
    return resolve(JSON.parse(this.storage.getItem(key)));
  }

  async has(key) {
    return this.storage.getItem(key) != null;
  }

  async save(key, obj) {
    if (obj == null) {
      // Fix safari not liking null in set
      this.storage.removeItem(key)
      return
    }

    this.storage.setItem(key, JSON.stringify(obj));
  }

  async remove(key) {
    this.storage.removeItem(key)
  }
}
