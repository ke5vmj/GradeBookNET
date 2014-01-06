using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Drawing.Wordprocessing;
using DocumentFormat.OpenXml.Office2010.PowerPoint;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;

namespace GradeBook.Utils
{
    /// <summary>
    /// Class wrapped around OpenXML to help create and export Spreadsheets
    /// </summary>
    public class SpreadSheetExport
    {
        private SpreadsheetDocument _spreadsheet;
        private MemoryStream _fileStream;

        public SpreadSheetExport()
        {
            this._spreadsheet = null;
            this._fileStream = new MemoryStream();
        }

        /// <summary>
        /// Creates a new spreadsheet
        /// </summary>
        /// <param name="fileName">Name of the file</param>
        /// <returns>The created spreadsheet</returns>
        public void CreateSpreadSheet()
        {
            try
            {
                //Creating the Excel workbook
                this._spreadsheet = SpreadsheetDocument.Create(this._fileStream, DocumentFormat.OpenXml.SpreadsheetDocumentType.Workbook, false);


                //Create the parts and corresponding objects
                this._spreadsheet.AddWorkbookPart();
                this._spreadsheet.WorkbookPart.Workbook = new Workbook();
                this._spreadsheet.WorkbookPart.Workbook.Save();

                // Sheets collection
                this._spreadsheet.WorkbookPart.Workbook.Sheets = new Sheets();
                this._spreadsheet.WorkbookPart.Workbook.Save();
            }
            catch (System.Exception exception)
            {
                throw new Exception("{0}", exception);
            }
        }

        /// <summary>
        /// Adds a new worksheet to the spreadsheet
        /// </summary>
        /// <param name="spreadsheet">The spreadsheet</param>
        /// <param name="name">name of the worksheet</param>
        /// <returns>True if success</returns>
        public bool AddWorkSheet(string name)
        {
            Sheets sheets = this._spreadsheet.WorkbookPart.Workbook.GetFirstChild<Sheets>();
            Sheet sheet;
            WorksheetPart worksheetPart;

            //Add the worksheetpart
            worksheetPart = this._spreadsheet.WorkbookPart.AddNewPart<WorksheetPart>();
            worksheetPart.Worksheet = new Worksheet(new SheetData());
            worksheetPart.Worksheet.Save();

            // Add the sheet to workbook
            sheet = new DocumentFormat.OpenXml.Spreadsheet.Sheet()
            {
                Id = this._spreadsheet.WorkbookPart.GetIdOfPart(worksheetPart),
                SheetId = (uint)(this._spreadsheet.WorkbookPart.Workbook.Sheets.Count() + 1),
                Name = name
            };

            sheets.Append(sheet);
            this._spreadsheet.WorkbookPart.Workbook.Save();

            return true;
        }

        /// <summary>
        /// Converts a column number to a column name
        /// </summary>
        /// <param name="columnIndex">Index of the column</param>
        /// <returns>Column name</returns>
        public string ColumnNameFromIndex(uint columnIndex)
        {
            uint remainder;
            string columnName = "";

            while (columnIndex > 0)
            {
                remainder = (columnIndex - 1) % 26;
                columnName = System.Convert.ToChar(65 + remainder).ToString() + columnName;
                columnIndex = (uint)((columnIndex - remainder) / 26);
            }

            return columnName;
        }

        /// <summary>
        /// Inserts a Cell into a worksheet
        /// </summary>
        /// <param name="columnName">Name of the colume</param>
        /// <param name="rowIndex">The row index</param>
        /// <param name="worksheetPart">The worksheet to add a cell to</param>
        /// <returns>The added cell </returns>
        private Cell InsertCellInWorksheet(string columnName, uint rowIndex, WorksheetPart worksheetPart)
        {
            Worksheet worksheet = worksheetPart.Worksheet;
            SheetData sheetData = worksheet.GetFirstChild<SheetData>();
            string cellReference = columnName + rowIndex;

            Row row;
            if(sheetData.Elements<Row>().Where(r => r.RowIndex == rowIndex).Count() != 0)
            {
                row = sheetData.Elements<Row>().Where(r => r.RowIndex == rowIndex).First();
            }
            else
            {
                row = new Row() { RowIndex = rowIndex};
                sheetData.Append(row);
            }

            if (row.Elements<Cell>().Where(c => c.CellReference.Value == columnName + rowIndex).Count() > 0)
            {
                return row.Elements<Cell>().Where(c => c.CellReference.Value == cellReference).First();
            }
            else
            {
                Cell refCell = null;

                foreach (Cell cell in row.Elements<Cell>())
                {
                    if (string.Compare(cell.CellReference.Value, cellReference, true) > 0)
                    {
                        refCell = cell;
                        break;
                    }
                }

                Cell newCell = new Cell() { CellReference = cellReference};
                row.InsertBefore(newCell, refCell);

                worksheet.Save();
                return newCell;
            }
        }

        /// <summary>
        /// Adds text into a cell at ColummName and rowIndex
        /// </summary>
        /// <param name="spreadsheet">The spreadsheet to be added to</param>
        /// <param name="value">Value of the cell</param>
        /// <param name="columnName">Name of the column</param>
        /// <param name="rowIndex">The row index</param>
        /// <param name="worksheet">The worksheet to be modified</param>
        public void InsertTextInCell(string value, string columnName, uint rowIndex, string worksheet)
        {
            SharedStringTablePart sharedStringPart;

            if (this._spreadsheet.WorkbookPart.GetPartsOfType<SharedStringTablePart>().Count() > 0)
            {
                sharedStringPart = this._spreadsheet.WorkbookPart.GetPartsOfType<SharedStringTablePart>().First();
            }
            else
            {
                sharedStringPart = this._spreadsheet.WorkbookPart.AddNewPart<SharedStringTablePart>();
            }

            int index = InsertSharedStringItem(value, sharedStringPart);


            // Get the necessary workSheet that we're going to modify
            WorksheetPart worksheetPart = _getWorkSheet(worksheet);

            //Inserts cell at specified locations
            Cell cell = InsertCellInWorksheet(columnName, rowIndex, worksheetPart);

            //Set the value at specified Cell
            cell.CellValue = new CellValue(index.ToString());
            cell.DataType = new EnumValue<CellValues>(CellValues.SharedString);

            //Save the worksheet
            worksheetPart.Worksheet.Save();
        }


        /// <summary>
        /// Inserts text into shared string item
        /// </summary>
        /// <param name="text">The value in string</param>
        /// <param name="shareStringPart">The shared part</param>
        /// <returns>The index</returns>
        private int InsertSharedStringItem(string text, SharedStringTablePart shareStringPart)
        {
            if (shareStringPart.SharedStringTable == null)
            {
                shareStringPart.SharedStringTable = new SharedStringTable();
            }

            int i = 0;


            foreach (SharedStringItem item in shareStringPart.SharedStringTable.Elements<SharedStringItem>())
            {
                if (item.InnerText == text)
                {
                    return i;
                }

                i++;
            }

            shareStringPart.SharedStringTable.AppendChild(
                new SharedStringItem(new DocumentFormat.OpenXml.Spreadsheet.Text(text)));
            shareStringPart.SharedStringTable.Save();

            return i;
        }

        /// <summary>
        /// Returns the worksheet by Id
        /// </summary>
        /// <param name="sheetId"></param>
        /// <param name="spreadsheet"></param>
        /// <returns></returns>
        private WorksheetPart _getWorkSheet(string sheetId)
        {
            string relId =
                this._spreadsheet.WorkbookPart.Workbook.Descendants<Sheet>().First(s => sheetId.Equals(s.Name)).Id;
            WorksheetPart wsp = (WorksheetPart) this._spreadsheet.WorkbookPart.GetPartById(relId);
            return wsp;
        }

        /// <summary>
        /// Pass a list of data items to create a data row
        /// </summary>
        /// <param name="sheetId">The ID of the Worksheet</param>
        /// <param name="dataItems">List of Dataitems</param>
        /// <param name="spreadsheet">The spreadsheet</param>
        public void AddRow(string sheetId, List<string> dataItems)
        {
            //Find the sheetdata of the worksheet
            SheetData sd = (SheetData) _getWorkSheet(sheetId).Worksheet.Where(x => x.LocalName == "sheetData").First();
            
            Row header = new Row();

            //increment the row index to the next row
            header.RowIndex = Convert.ToUInt32(sd.ChildElements.Count()) + 1;

            sd.Append(header);

            foreach (string item in dataItems)
            {
                AppendCell(header, header.RowIndex, item);
            }

            _getWorkSheet(sheetId).Worksheet.Save();
        }


        /// <summary>
        /// Add cell into the passed row
        /// </summary>
        /// <param name="row">The row to add a cell to</param>
        /// <param name="rowIndex">The index of the row</param>
        /// <param name="value">The value for the cell</param>
        public void AppendCell(Row row, uint rowIndex, string value)
        {
            Cell cell = new Cell();
            cell.DataType = CellValues.InlineString;
            Text t = new Text();
            t.Text = value;

            //Append the Text
            InlineString inlineString = new InlineString();
            inlineString.AppendChild(t);

            //Append to cell
            cell.AppendChild(inlineString);

            // Get the last cell's column
            string nextCol = "A";
            Cell c = (Cell) row.LastChild;

            if (c != null) // if cells exist
            {
                int numIndex = c.CellReference.ToString().IndexOfAny(new char[] {'1', '2', '3', '4', '5', '6', '7', '8', '9'});
                
                //Get the last column ref
                string lastCol = c.CellReference.ToString().Substring(0, numIndex);

                nextCol = IncrementColRef(lastCol);
            }

            cell.CellReference = nextCol + rowIndex;

            row.AppendChild(cell);
        }


        /// <summary>
        /// Increments the column reference of an Excel.. A,B,C...Z,A
        /// </summary>
        /// <param name="lastRef">Last column</param>
        /// <returns></returns>
        public string IncrementColRef(string lastRef)
        {
            char[] characters = lastRef.ToUpperInvariant().ToCharArray();
            int sum = 0;

            for (int i = 0; i < characters.Length; i++)
            {
                sum *= 26;
                sum += (characters[i] - 'A' + 1);
            }

            sum++;

            string columnName = String.Empty;
            int modulo;

            while (sum > 0)
            {
                modulo = (sum - 1) % 26;
                columnName = Convert.ToChar(65 + modulo).ToString() + columnName;
                sum = (int) ((sum - modulo)/26);
            }

            return columnName;
        }

        /// <summary>
        /// Takes the working Excel file and streams to user
        /// </summary>
        /// <param name="spreadsheet">Current spreadsheet</param>
        /// <param name="fileStream">The stream to send</param>
        public void ExcelToResponse()
        {
            HttpContext.Current.Response.ClearHeaders();
            HttpContext.Current.Response.ClearContent();
            HttpContext.Current.Response.Clear();
            HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment; filename=Export.xlsx");
            HttpContext.Current.Response.ContentType =
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

            this._spreadsheet.Close();
            
            this._fileStream.WriteTo(HttpContext.Current.Response.OutputStream);
            this._fileStream.Close();
            HttpContext.Current.Response.End();
        }
    }
}