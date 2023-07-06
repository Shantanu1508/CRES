using OpenQA.Selenium;
using OpenQA.Selenium.Remote;
using System;

namespace CRES.TestAutoMation.Utility
{
    public class WijmoHelper
    {
        public static void CreateFlexGridObject(RemoteWebDriver browser, string controlid)
        {
            var script = $"window['gridObj'] = wijmo.Control.getControl({controlid});";
            browser.ExecuteScript(script);
        }

        public static IWebElement GetCellElement(RemoteWebDriver browser, int row, int col)
        {
            var script = $"return window['gridObj'].cells.getCellElement({row}, {col});";
            var elem = (IWebElement)browser.ExecuteScript(script);
            return elem;
        }

        public static void SetCellElement(RemoteWebDriver browser, int row, int col, string value)
        {
            string strue = "true";
            var script = $"return window['gridObj'].setCellData({row}, {col},'{value}',{strue});";
            var elem = browser.ExecuteScript(script);
        }

        public static void AddNewRowInGrid(RemoteWebDriver browser)
        {
            //gridObj.rows.splice(0,0,new wijmo.grid.Row())
            var script = $"return window['gridObj'].rows.splice(0,0,new wijmo.grid.Row());";
            var elem = browser.ExecuteScript(script);
        }

        public static int GetColumnIndex(RemoteWebDriver browser, string binding)
        {
            var script = $"return window['gridObj'].columns.getColumn('{binding}').index";
            return Convert.ToInt32(browser.ExecuteScript(script));
        }
        public static int GetVisibleRows(RemoteWebDriver browser)
        {
            var script = "return window['gridObj'].viewRange.bottomRow";
            return Convert.ToInt32(browser.ExecuteScript(script));
        }
        public static string GetDataSource(RemoteWebDriver browser)
        {
            var script = "return window['gridObj'].itemsSource.items";

            var json = browser.ExecuteScript(script);
            return Convert.ToString(browser.ExecuteScript(script));
        }



    }
}
