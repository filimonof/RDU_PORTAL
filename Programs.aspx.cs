using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Diagnostics;


public partial class Programs : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        this.Page.Title += " - Программы";
        if (!this.IsPostBack)
        { }
    }

    public void Perf()
    {
        PerformanceCounter perf = new PerformanceCounter("Hyper-V Hypervisor Logical Processor", "% Total Run Time", "_Total");
        this.LabelPerf.Text = string.Format("{0}", perf.NextValue());
        /*
To get the entire PC CPU and Memory usage:
import System.Diagnostics;

Then declare globally:
private PerformanceCounter theCPUCounter = new PerformanceCounter("Processor", "% Processor Time", "_Total"); 

Then to get the CPU time, simply call the NextValue() method:
this.theCPUCounter.NextValue();

This will get you the CPU usage
As for memory usage, same thing applies I believe:
private PerformanceCounter theMemCounter = new PerformanceCounter("Memory", "Available MBytes");

Then to get the memory usage, simply call the NextValue() method:
this.theMemCounter.NextValue();

For a specific process CPU and Memory usage:
private PerformanceCounter theCPUCounter = new PerformanceCounter("Process", "% Processor Time", Process.GetCurrentProcess().ProcessName);

where Process.GetCurrentProcess().ProcessName is the process name you wish to get the information about.
private PerformanceCounter theMemCounter = new PerformanceCounter("Memory", "Available MBytes", Process.GetCurrentProcess().ProcessName);

Pelo Hyper-V:

private PerformanceCounter theMemCounter = new PerformanceCounter(
    "Hyper-v Dynamic Memory VM",
    "Physical Memory",
    Process.GetCurrentProcess().ProcessName); 


         * 
         http://blogs.msdn.com/b/taylorb/archive/2008/05/21/hyper-v-wmi-using-powershell-part-4-and-negative-1.aspx 
         */
    }
}