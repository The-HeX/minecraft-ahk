using System;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading;
using Patagames.Ocr;
using Patagames.Ocr.Enums;

namespace ConsoleApplication1
{
    internal class Program
    {
        private static void Main(string[] args)
        {

            // FIND THE MOST RECENT FILE
            var dir = Environment.GetFolderPath(Environment.SpecialFolder.MyVideos);
            var file=Directory.GetFiles(dir + @"\Captures")
                .Select(a => new {Date = File.GetLastWriteTime(a), Name = a}).OrderByDescending(a => a.Date).FirstOrDefault();
            if (file != null)
            {
                var count = 1;
                var success = false;
                do
                {
                    try
                    {
                        // CROP DISPLAY . RETURN FILENAME
                        var cropped = CropScreenSections(file.Name);
                        // PARSE FILE NAME
                        var value = ParseData(cropped);
                        // WRITE FILE, TO ARG LOCATION
                        var path = args.Length > 0 ? args[0] : Path.GetTempFileName();
                        Console.WriteLine($"writing results {value} to {path}");
                        using (var output = File.CreateText(path))
                        {
                            output.WriteLine(value);
                        }
                        success = true;
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine(e);
                        Thread.Sleep(750);
                    }
                } while (!success && count < 3);
            }
        }

        private static string ParseData(string imagename)
        {
            using (var api = OcrApi.Create())
            {
                api.Init(Languages.English,null, OcrEngineMode.OEM_TESSERACT_ONLY);

                var plainText = api.GetTextFromImage(imagename);

                var format = plainText.Split('\n')[0];
                return CleanString(format);
            }
        }

        private static string CleanString(string format)
        {
            var charToReplace = (new string[]
            {
                "`",
                "'",
                "~",
                ".",
                ",",
                ":",
                "Position",
                "\r",
                "\n"
            }).ToList();

            foreach (var replace in charToReplace)
            {
                format = format.Replace(replace, " ");
            }
            Regex rgx = new Regex("[^a-zA-Z0-9 -]");
            format = rgx.Replace(format, "");
            return format.Replace("  "," ")
                    .TrimStart(' ')
                    .TrimEnd(' ');
        }


        private static string CropScreenSections(string filename)
        {
                var src = Image.FromFile(filename);
                return CropDisplay(src, filename);
                
        }

        private static string CropDisplay(Image src, string input)
        {
            var y1 = 33;
            var y2 = 70;
            var x1 = 1;
            var x2 = 440;
            if (y2 > src.Height)
                y2 = src.Height;
            var rect = new Rectangle(x1, y1, x2 - x1, y2 - y1);
            var cropped = cropImage(src, rect);
            var filename = Path.GetTempFileName() + ".png";
            //var filename = @"c:\temp\screenshots\display\" + Path.GetFileName(input);
            if (File.Exists(filename))
                File.Delete(filename);
            cropped.Save(filename);
            return filename;
        }

     

        private static Image cropImage(Image img, Rectangle cropArea)
        {
            var bmpImage = new Bitmap(img);
            return bmpImage.Clone(cropArea, bmpImage.PixelFormat);
        }
    }
}