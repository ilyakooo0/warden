import { test, expect, Page } from '@playwright/test';

async function logIn(page: Page) {
  await page.locator('input[type="url"]').tap();
  await page.locator('input[type="url"]').press('Control+a');
  await page.locator('input[type="url"]').fill('http://localhost:8000');
  await page.locator('input[type="email"]').tap();
  await page.locator('input[type="email"]').fill('test@example.com');
  await page.locator('input[type="password"]').tap();
  await page.locator('input[type="password"]').fill('Password123');
  await page.getByRole('button', { name: 'Log in' }).tap();
  await page.locator('.p-icon--spinner.u-animation--spin.spinner').waitFor({ state: "visible" })
  await page.locator('.p-icon--spinner.u-animation--spin.spinner').waitFor({ state: "hidden" })
}

async function fillInLoginCipher(page: Page) {
  await page.locator('p:has-text("Entry name") input[type="text"]').tap();
  await page.locator('p:has-text("Entry name") input[type="text"]').fill('Test login entry');
  await page.locator('p:has-text("Username") input[type="text"]').tap();
  await page.locator('p:has-text("Username") input[type="text"]').fill('login_entry_username');
  await page.locator('input[type="text"]').nth(2).tap();
  await page.locator('input[type="text"]').nth(2).fill('Password123');
  await page.locator('input[type="url"]').tap();
  await page.locator('input[type="url"]').fill('https://example.com');
}

async function fillInCardCipher(page: Page) {
  await page.locator('p:has-text("Entry name") input[type="text"]').tap();
  await page.locator('p:has-text("Entry name") input[type="text"]').fill('Test card');
  await page.locator('p:has-text("Card number") input[type="text"]').tap();
  await page.locator('p:has-text("Card number") input[type="text"]').fill('1234567890123456');
  await page.locator('p:has-text("Expiration date /") input[type="text"]').first().tap();
  await page.locator('p:has-text("Expiration date /") input[type="text"]').first().fill('01');
  await page.locator('p:has-text("Expiration date /") input[type="text"]').nth(1).tap();
  await page.locator('p:has-text("Expiration date /") input[type="text"]').nth(1).fill('01');
  await page.locator('p:has-text("CVV") input[type="text"]').tap();
  await page.locator('p:has-text("CVV") input[type="text"]').fill('123');
  await page.locator('p:has-text("Cardholder name") input[type="text"]').tap();
  await page.locator('p:has-text("Cardholder name") input[type="text"]').fill('Sampel Palnet');
}

async function fillInNoteCipher(page: Page) {
  await page.locator('input[type="text"]').tap();
  await page.locator('input[type="text"]').fill('Secret note');
  await page.locator('textarea').tap();
  await page.locator('textarea').fill('This is a very secret note');
}

async function fillInContractCipher(page: Page) {
  await page.locator('p:has-text("Entry name") input[type="text"]').tap();
  await page.locator('p:has-text("Entry name") input[type="text"]').fill('John Appleseed');
  await page.locator('p:has-text("First name") input[type="text"]').tap();
  await page.locator('p:has-text("First name") input[type="text"]').fill('John');
  await page.locator('p:has-text("Middle name") input[type="text"]').tap();
  await page.locator('p:has-text("Middle name") input[type="text"]').fill('Mathews');
  await page.locator('p:has-text("Last name") input[type="text"]').tap();
  await page.locator('p:has-text("Last name") input[type="text"]').fill('Appleseed');
  await page.locator('p:has-text("Username") input[type="text"]').tap();
  await page.locator('p:has-text("Username") input[type="text"]').fill('jappleseed');
  await page.locator('p:has-text("Company") input[type="text"]').tap();
  await page.locator('p:has-text("Company") input[type="text"]').fill('Very good building company');
  await page.locator('p:has-text("Social security number") input[type="number"]').tap();
  await page.locator('p:has-text("Social security number") input[type="number"]').fill('123456789');
  await page.locator('p:has-text("Passport number") input[type="number"]').tap();
  await page.locator('p:has-text("Passport number") input[type="number"]').fill('123456798');
  await page.locator('p:has-text("License Number") input[type="number"]').tap();
  await page.locator('p:has-text("License Number") input[type="number"]').fill('12345');
  await page.locator('input[type="email"]').tap();
  await page.locator('input[type="email"]').fill('john@example.com');
  await page.locator('input[type="tel"]').tap();
  await page.locator('input[type="tel"]').fill('123456789');
  await page.locator('p:has-text("Address line 1") input[type="text"]').tap();
  await page.locator('p:has-text("Address line 1") input[type="text"]').fill('Abc def');
  await page.locator('p:has-text("Address line 2") input[type="text"]').tap();
  await page.locator('p:has-text("Address line 2") input[type="text"]').fill('Ghijk Lmn');
}

async function screenshot(page: Page) {
  await page.waitForLoadState("networkidle")

  if (await page.locator('div.floating-notifications').isVisible()) {
    await page.locator("button.p-notification__close").tap()
    await screenshot(page)
  } else if (await page.locator('.p-icon--spinner.u-animation--spin.spinner').isVisible()) {
    await page.locator('.p-icon--spinner.u-animation--spin.spinner').waitFor({ state: "hidden" })
    await screenshot(page)
  } else {
    await expect.soft(page).toHaveScreenshot({ animations: "disabled", fullPage: true })
  }
}

async function waitForNotification(page: Page) {
  await page.locator('div.floating-notifications').waitFor({ state: "visible" })
}


/**
 * Screenshots the very first (last edited) entry.
 */
function cipherPage(name: string) {
  test(name + " cipher page", async ({ page }) => {
    await logIn(page)

    await page.locator('.cipher-row').first().tap()

    await screenshot(page)
  })
}

test.beforeEach(async ({ page }) => {
  await page.goto(`file://${__dirname}/../../build/all/app/install/index.html`);
  await page.addStyleTag({ content: '.hide-in-test {opacity: 0;}' })
})

if (process.env.RECORD_TEST === "true") {

  test('record', async ({ page }) => {
    await logIn(page)
    await page.pause()
  })

} else {
  test('Login page', async ({ page }) => {
    await screenshot(page)
  });

  test('Empty ciphers page', async ({ page }) => {
    await logIn(page)

    await screenshot(page)
  })

  test('Login entry page', async ({ page }) => {
    await logIn(page)

    await page.getByRole('button').nth(2).tap();
    await page.getByRole('button', { name: 'Login' }).tap();

    await screenshot(page)

    await fillInLoginCipher(page)

    await screenshot(page)

    await page.getByRole('heading').locator('span').getByRole('button').tap();

    await waitForNotification(page)
  });

  cipherPage("Login")

  test('Create Card entry page', async ({ page }) => {
    await logIn(page)

    await page.getByRole('button').nth(2).tap();
    await page.getByRole('button', { name: 'Card' }).tap();

    await screenshot(page)

    await fillInCardCipher(page)

    await screenshot(page)

    await page.getByRole('heading').locator('span').getByRole('button').tap();

    await waitForNotification(page)
  })

  cipherPage("Card")

  test('Create Note entry page', async ({ page }) => {
    await logIn(page)

    await page.getByRole('button').nth(2).tap();
    await page.getByRole('button', { name: 'Note' }).tap();

    await screenshot(page)

    await fillInNoteCipher(page)

    await screenshot(page)

    await page.getByRole('heading').locator('span').getByRole('button').tap();

    await waitForNotification(page)
  })

  cipherPage("Note")

  test('Create Contact entry page', async ({ page }) => {
    await logIn(page)

    await page.getByRole('button').nth(2).tap();
    await page.getByRole('button', { name: 'Contact' }).tap();

    await screenshot(page)

    await fillInContractCipher(page)

    await screenshot(page)

    await page.getByRole('heading').locator('span').getByRole('button').tap();

    await waitForNotification(page)
  })

  cipherPage("Contact")

  test('Filled ciphers page', async ({ page }) => {
    await logIn(page)
    await screenshot(page)
  })

  test('Side bar', async ({ page }) => {
    await logIn(page)

    await page.getByRole('button').nth(1).tap();

    await screenshot(page)
  })

  test('Passwords view', async ({ page }) => {
    await logIn(page)

    await page.getByRole('button').nth(1).click();
    await page.getByText('Passwords').click();

    await screenshot(page)
  })

  test('Notes view', async ({ page }) => {
    await logIn(page)

    await page.getByRole('button').nth(1).click();
    await page.getByText('Notes').click();

    await screenshot(page)
  })

  test('Cards view', async ({ page }) => {
    await logIn(page)

    await page.getByRole('button').nth(1).click();
    await page.getByText('Cards').click();

    await screenshot(page)
  })

  test('Contacts view', async ({ page }) => {
    await logIn(page)

    await page.getByRole('button').nth(1).click();
    await page.getByText('Contacts').click();

    await screenshot(page)
  })
}
