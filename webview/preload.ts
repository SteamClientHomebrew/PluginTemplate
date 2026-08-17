/**
 * This preload module is injected into all well known steam urls.
 * - Store
 * - Community
 * - etc
 *
 * It does NOT have access to React, or any other frameworks then the
 * raw DOM.
 *
 * This includes @steamclienthomebrew/millennium as its only made for the Steam
 * Client, not external, insecure pages.
 */

/**
 * This function is called by Millennium once this script has been loaded.
 * This is no guarantee that the DOM or window is.
 *
 * The frontend and backend will be loaded.
 */
export default async function main() {
  console.log("Attached to:", window.location.href);

  const sum = await backend.add(100, 100, 100);
  console.log("Result from add:", sum);

  const result = await frontend.subtract(200, 100);
  console.log("Result from subtract:", result.difference);
}
