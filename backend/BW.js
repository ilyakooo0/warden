import { StateFactory } from "../../deps/bw/libs/shared/dist/src/factories/stateFactory";
import { GlobalState } from "../../deps/bw/libs/shared/dist/src/models/domain/globalState";
import { ApiService } from "../../deps/bw/libs/shared/dist/src/services/api.service";
import { AppIdService } from "../../deps/bw/libs/shared/dist/src/services/appId.service";
import { ConsoleLogService } from "../../deps/bw/libs/shared/dist/src/services/consoleLog.service";
import { EnvironmentService } from "../../deps/bw/libs/shared/dist/src/services/environment.service";
import { StateMigrationService } from "../../deps/bw/libs/shared/dist/src/services/stateMigration.service";
import { TokenService } from "../../deps/bw/libs/shared/dist/src/services/token.service";
import { WebCryptoFunctionService } from "../../deps/bw/libs/shared/dist/src/services/webCryptoFunction.service";
import { Account, AccountProfile, AccountTokens } from "../../deps/bw/libs/shared/dist/src/models/domain/account";

// import BrowserStorageService from "../../../../deps/bw/libs/shared/dist/src/services/browserStorage.service";
import { CryptoService } from "../../deps/bw/libs/shared/dist/src/services/crypto.service";

import { I18nService } from "../../deps/bw/libs/shared/dist/src/services/i18n.service";
import { StateService as BaseStateService } from "../../deps/bw/libs/shared/dist/src/services/state.service";
import { PasswordTokenRequest } from "../../deps/bw/libs/shared/dist/src/models/request/identityToken/passwordTokenRequest";
import { TokenRequestTwoFactor } from "../../deps/bw/libs/common/src/models/request/identityToken/tokenRequestTwoFactor";
import { CipherRequest } from "../../deps/bw/libs/common/src/models/request/cipherRequest";
import { CipherCreateRequest } from "../../deps/bw/libs/common/src/models/request/cipherCreateRequest";
import { Cipher } from "../../deps/bw/libs/common/src/models/domain/cipher";
import { CipherData } from "../../deps/bw/libs/common/src/models/data/cipherData";
import { PasswordGenerationService } from "../../deps/bw/libs/common/src/services/passwordGeneration.service";

function sanitize(obj) {
  return JSON.parse(JSON.stringify(obj));
}

export function getServices() {
  const bg = new MainBackground()

  return {
    getApi: (urls) => async (tokenResponse) => {
      const bg = new MainBackground()

      await bg.bootstrap()

      bg.environmentService.setUrls(urls)

      if (tokenResponse != null) {
        const accountInformation = await bg.tokenService.decodeToken(tokenResponse.accessToken);
        await bg.stateService.addAccount(
          new Account({
            profile: {
              ...new AccountProfile(),
              ...{
                userId: accountInformation.sub,
                email: accountInformation.email,
                hasPremiumPersonally: accountInformation.premium,
                kdfIterations: tokenResponse.kdfIterations,
                kdfType: tokenResponse.kdf,
              },
            },
            tokens: {
              ...new AccountTokens(),
              ...{
                accessToken: tokenResponse.accessToken,
                refreshToken: tokenResponse.refreshToken,
              },
            },
          })
        );
      }

      const api = bg.apiService

      return {
        postPrelogin: (req) => api.postPrelogin(req),
        getProfile: (req) => api.getProfile(req),
        postIdentityToken: (req) => api.postIdentityToken(
          new PasswordTokenRequest(
            req.email,
            req.masterPasswordHash,
            req.captchaResponse,
            new TokenRequestTwoFactor(req.twoFactor),
            req.device
          )
        ),
        getSync: () => api.getSync().then(sanitize),
        postCipherCreate: (cipher) => api.postCipherCreate(makeCipherCreateRequest(cipher)),
        putCipher: (cipher) => api.putCipher(cipher.id, makeCipherRequest(cipher)),
        deleteCipher: (id) => api.deleteCipher(id),
      }
    },
    crypto: bg.cryptoService,
    cryptoFunctions: bg.cryptoFunctionService,
    passwordGeneration: bg.passwordGenerationService
  }
}

function makeCipherRequest(cipher) {
  return new CipherRequest(new Cipher(new CipherData(cipher)))
}

function makeCipherCreateRequest(cipher) {
  return new CipherCreateRequest(new Cipher(new CipherData(cipher)))
}

class MainBackground {
  // messagingService; //: MessagingServiceAbstraction;
  // storageService; //: StorageServiceAbstraction;
  // i18nService; //: I18nServiceAbstraction;
  // platformUtilsService; //: PlatformUtilsServiceAbstraction;
  // logService; //: LogServiceAbstraction;
  // cryptoService; //: CryptoServiceAbstraction;
  // cryptoFunctionService; //: CryptoFunctionServiceAbstraction;
  // tokenService; //: TokenServiceAbstraction;
  // appIdService; //: AppIdServiceAbstraction;
  // apiService; //: ApiServiceAbstraction;
  // environmentService; //: EnvironmentServiceAbstraction;
  // authService; //: AuthServiceAbstraction;
  // stateService; //: StateServiceAbstraction;
  // stateMigrationService; //: StateMigrationService;


  constructor() {

    this.messagingService = new BrowserMessagingService();
    this.storageService = new MemoryStorageService();
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
    this.i18nService = new I18nService("en");
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
    this.passwordGenerationService = new PasswordGenerationService(
      this.cryptoService,
      this.policyService,
      this.stateService
    );
  }

  async bootstrap() {
    await this.stateService.init();

    await (this.i18nService).init();
  }

  async logout(expired, userId) {
    await this.eventService.uploadEvents(userId);

    await Promise.all([
      this.cryptoService.clearKeys(userId)
    ]);

    await this.stateService.clean({ userId: userId });
  }
}

class MemoryStorageService {

  constructor() {
    this.storage = {};
  }

  async get(key) {
    return this.storage[key]
  }

  async has(key) {
    return key in this.storage;
  }

  async save(key, obj) {
    if (obj == null) {
      this.remove(key)
      return
    }

    this.storage[key] = obj
  }

  async remove(key) {
    delete this.storage[key]
  }
}

class BrowserCryptoService extends CryptoService {
  async retrieveKeyFromStorage(keySuffix) {
    if (keySuffix === "biometric") {
      await this.platformUtilService.authenticateBiometric();
      const k = await this.getKey()
      if (k == null) {
        return null
      } else {
        return k.keyB64
      }
    }

    return await super.retrieveKeyFromStorage(keySuffix);
  }
}

class BrowserMessagingService {
  send(subscriber, arg = {}) {
    const message = Object.assign({}, { command: subscriber }, arg);
    chrome.runtime.sendMessage(message);
  }
}

class BrowserPlatformUtilsService {
  constructor(messagingService, stateService, clipboardWriteCallback, biometricCallback) {
    this.messagingService = messagingService;
    this.stateService = stateService;
    this.clipboardWriteCallback = clipboardWriteCallback;
    this.biometricCallback = biometricCallback;
    this.showDialogResolves = new Map();
    this.passwordDialogResolves = new Map();
    this.deviceCache = null;
    this.prefersColorSchemeDark = window.matchMedia("(prefers-color-scheme: dark)");
  }
  getDevice() {
    return 9; // Chrome
  }
  getDeviceString() {
    const device = DeviceType[this.getDevice()].toLowerCase();
    return device.replace("extension", "");
  }
  getClientType() {
    return "browser";
  }
  isFirefox() {
    return this.getDevice() === DeviceType.FirefoxExtension;
  }
  isChrome() {
    return this.getDevice() === DeviceType.ChromeExtension;
  }
  isEdge() {
    return this.getDevice() === DeviceType.EdgeExtension;
  }
  isOpera() {
    return this.getDevice() === DeviceType.OperaExtension;
  }
  isVivaldi() {
    return this.getDevice() === DeviceType.VivaldiExtension;
  }
  isSafari() {
    return this.getDevice() === DeviceType.SafariExtension;
  }
  isIE() {
    return false;
  }
  isMacAppStore() {
    return false;
  }
  isViewOpen() {
    return true;
  }
  lockTimeout() {
    return null;
  }
  launchUri(uri, options) {
    // BrowserApi.createNewTab(uri, options && options.extensionPage === true);
  }
  saveFile(win, blobData, blobOptions, fileName) {
    // BrowserApi.downloadFile(win, blobData, blobOptions, fileName);
  }
  getApplicationVersion() {
    // return Promise.resolve(BrowserApi.getApplicationVersion());
  }
  supportsWebAuthn(win) {
    return typeof PublicKeyCredential !== "undefined";
  }
  supportsDuo() {
    return true;
  }
  showToast(type, title, text, options) {
    this.messagingService.send("showToast", {
      text: text,
      title: title,
      type: type,
      options: options,
    });
  }
  showDialog(body, title, confirmText, cancelText, type, bodyIsHtml = false) {
    const dialogId = Math.floor(Math.random() * Number.MAX_SAFE_INTEGER);
    this.messagingService.send("showDialog", {
      text: bodyIsHtml ? null : body,
      html: bodyIsHtml ? body : null,
      title: title,
      confirmText: confirmText,
      cancelText: cancelText,
      type: type,
      dialogId: dialogId,
    });
    return new Promise((resolve) => {
      this.showDialogResolves.set(dialogId, { resolve: resolve, date: new Date() });
    });
  }
  isDev() {
    return false;
  }
  isSelfHost() {
    return true;
  }
  copyToClipboard(text, options) {
    let win = window;
    let doc = window.document;
    if (options && (options.window || options.win)) {
      win = options.window || options.win;
      doc = win.document;
    }
    else if (options && options.doc) {
      doc = options.doc;
    }
    const clearing = options ? !!options.clearing : false;
    const clearMs = options && options.clearMs ? options.clearMs : null;
    if (this.isSafari()) {
      SafariApp.sendMessageToApp("copyToClipboard", text).then(() => {
        if (!clearing && this.clipboardWriteCallback != null) {
          this.clipboardWriteCallback(text, clearMs);
        }
      });
    }
    else if (this.isFirefox() &&
      win.navigator.clipboard &&
      win.navigator.clipboard.writeText) {
      win.navigator.clipboard.writeText(text).then(() => {
        if (!clearing && this.clipboardWriteCallback != null) {
          this.clipboardWriteCallback(text, clearMs);
        }
      });
    }
    else if (win.clipboardData && win.clipboardData.setData) {
      // IE specific code path to prevent textarea being shown while dialog is visible.
      win.clipboardData.setData("Text", text);
      if (!clearing && this.clipboardWriteCallback != null) {
        this.clipboardWriteCallback(text, clearMs);
      }
    }
    else if (doc.queryCommandSupported && doc.queryCommandSupported("copy")) {
      if (this.isChrome() && text === "") {
        text = "\u0000";
      }
      const textarea = doc.createElement("textarea");
      textarea.textContent = text == null || text === "" ? " " : text;
      // Prevent scrolling to bottom of page in MS Edge.
      textarea.style.position = "fixed";
      doc.body.appendChild(textarea);
      textarea.select();
      try {
        // Security exception may be thrown by some browsers.
        if (doc.execCommand("copy") && !clearing && this.clipboardWriteCallback != null) {
          this.clipboardWriteCallback(text, clearMs);
        }
      }
      catch (e) {
        // eslint-disable-next-line
        console.warn("Copy to clipboard failed.", e);
      }
      finally {
        doc.body.removeChild(textarea);
      }
    }
  }
  readFromClipboard(options) {
    return __awaiter(this, void 0, void 0, function* () {
      let win = window;
      let doc = window.document;
      if (options && (options.window || options.win)) {
        win = options.window || options.win;
        doc = win.document;
      }
      else if (options && options.doc) {
        doc = options.doc;
      }
      if (this.isSafari()) {
        return yield SafariApp.sendMessageToApp("readFromClipboard");
      }
      else if (this.isFirefox() &&
        win.navigator.clipboard &&
        win.navigator.clipboard.readText) {
        return yield win.navigator.clipboard.readText();
      }
      else if (doc.queryCommandSupported && doc.queryCommandSupported("paste")) {
        const textarea = doc.createElement("textarea");
        // Prevent scrolling to bottom of page in MS Edge.
        textarea.style.position = "fixed";
        doc.body.appendChild(textarea);
        textarea.focus();
        try {
          // Security exception may be thrown by some browsers.
          if (doc.execCommand("paste")) {
            return textarea.value;
          }
        }
        catch (e) {
          // eslint-disable-next-line
          console.warn("Read from clipboard failed.", e);
        }
        finally {
          doc.body.removeChild(textarea);
        }
      }
      return null;
    });
  }
  resolveDialogPromise(dialogId, confirmed) {
    if (this.showDialogResolves.has(dialogId)) {
      const resolveObj = this.showDialogResolves.get(dialogId);
      resolveObj.resolve(confirmed);
      this.showDialogResolves.delete(dialogId);
    }
    // Clean up old promises
    this.showDialogResolves.forEach((val, key) => {
      const age = new Date().getTime() - val.date.getTime();
      if (age > DialogPromiseExpiration) {
        this.showDialogResolves.delete(key);
      }
    });
  }
  resolvePasswordDialogPromise(dialogId, canceled, password) {
    return __awaiter(this, void 0, void 0, function* () {
      let result = false;
      if (this.passwordDialogResolves.has(dialogId)) {
        const resolveObj = this.passwordDialogResolves.get(dialogId);
        if (yield resolveObj.tryResolve(canceled, password)) {
          this.passwordDialogResolves.delete(dialogId);
          result = true;
        }
      }
      // Clean up old promises
      this.passwordDialogResolves.forEach((val, key) => {
        const age = new Date().getTime() - val.date.getTime();
        if (age > DialogPromiseExpiration) {
          this.passwordDialogResolves.delete(key);
        }
      });
      return result;
    });
  }
  supportsBiometric() {
    return false;
  }
  authenticateBiometric() {
    return this.biometricCallback();
  }
  sidebarViewName() {
    if (window.chrome.sidebarAction && this.isFirefox()) {
      return "sidebar";
    }
    else if (this.isOpera() && typeof opr !== "undefined" && opr.sidebarAction) {
      return "sidebar_panel";
    }
    return null;
  }
  supportsSecureStorage() {
    return false;
  }
  getDefaultSystemTheme() {
    return Promise.resolve(this.prefersColorSchemeDark.matches ? ThemeType.Dark : ThemeType.Light);
  }
  onDefaultSystemThemeChange(callback) {
    this.prefersColorSchemeDark.addEventListener("change", ({ matches }) => {
      callback(matches ? ThemeType.Dark : ThemeType.Light);
    });
  }
  getEffectiveTheme() {
    return __awaiter(this, void 0, void 0, function* () {
      const theme = (yield this.stateService.getTheme());
      if (theme == null || theme === ThemeType.System) {
        return this.getDefaultSystemTheme();
      }
      else {
        return theme;
      }
    });
  }
}

class StateService extends BaseStateService {
  async addAccount(account) {
    // Apply browser overrides to default account values
    account = new Account(account);
    await super.addAccount(account);
  }

  async getIsAuthenticated(options) {
    // Firefox Private Mode can clash with non-Private Mode because they both read from the same onDiskOptions
    // Check that there is an account in memory before considering the user authenticated
    return (
      (await super.getIsAuthenticated(options)) &&
      (await this.getAccount(this.defaultInMemoryOptions)) != null
    );
  }

  async getBrowserGroupingComponentState(options) {
    const x = await this.getAccount(this.reconcileOptions(options, this.defaultInMemoryOptions))
    return x == null ? null : x.groupings;
  }

  async setBrowserGroupingComponentState(value, options) {
    const account = await this.getAccount(
      this.reconcileOptions(options, this.defaultInMemoryOptions)
    );
    account.groupings = value;
    await this.saveAccount(account, this.reconcileOptions(options, this.defaultInMemoryOptions));
  }

  async getBrowserCipherComponentState(options) {
    const x = await this.getAccount(this.reconcileOptions(options, this.defaultInMemoryOptions))
    return x == null ? null : x.ciphers;
  }

  async setBrowserCipherComponentState(value, options) {
    const account = await this.getAccount(
      this.reconcileOptions(options, this.defaultInMemoryOptions)
    );
    account.ciphers = value;
    await this.saveAccount(account, this.reconcileOptions(options, this.defaultInMemoryOptions));
  }

  async getBrowserSendComponentState(options) {
    const x = await this.getAccount(this.reconcileOptions(options, this.defaultInMemoryOptions))
    return x == null ? null : x.send;
  }

  async setBrowserSendComponentState(value, options) {
    const account = await this.getAccount(
      this.reconcileOptions(options, this.defaultInMemoryOptions)
    );
    account.send = value;
    await this.saveAccount(account, this.reconcileOptions(options, this.defaultInMemoryOptions));
  }
  async getBrowserSendTypeComponentState(options) {
    const x = await this.getAccount(this.reconcileOptions(options, this.defaultInMemoryOptions))
    return x == null ? null : x.sendType;
  }

  async setBrowserSendTypeComponentState(value, options) {
    const account = await this.getAccount(
      this.reconcileOptions(options, this.defaultInMemoryOptions)
    );
    account.sendType = value;
    await this.saveAccount(account, this.reconcileOptions(options, this.defaultInMemoryOptions));
  }
}
