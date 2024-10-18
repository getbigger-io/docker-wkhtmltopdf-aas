const express = require("express");
const puppeteer = require("puppeteer");

const app = express();
const port = 80;
const appPrefix = "puppeteer-pdf-app";
app.use(express.json());
app.post("/", async (req, res) => {
  let browser = null;
  try {
    const data = Buffer.from(req.body.contents, "base64");

    const browser = await puppeteer.launch({
      executablePath: "/usr/bin/chromium",
      args: ["--no-sandbox"],
    });

    const page = await browser.newPage();

    await page.setContent(data.toString(), { waitUntil: "domcontentloaded" });

    await page.emulateMediaType("screen");

    // Downlaod the PDF
    const pdf = await page.pdf({
      margin: { top: "100px", right: "50px", bottom: "100px", left: "50px" },
      printBackground: true,
      format: "A4",
      ...req.body,
    });

    res.send(Buffer.from(pdf));
  } catch (e) {
    console.log(e);
    throw e;
  } finally {
    try {
      await browser?.close();
    } catch (e) {}
  }
});

app.listen(port, () => {
  console.log(`Puppeteer Pdf AAS app listening on port ${port}`);
});
