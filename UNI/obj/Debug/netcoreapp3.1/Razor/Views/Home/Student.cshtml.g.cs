#pragma checksum "C:\Users\Abdusattar\RiderProjects\UNI\UNI\Views\Home\Student.cshtml" "{ff1816ec-aa5e-4d10-87f7-6f4963833460}" "d232b284a060bab74069afc4cc96efa53d05a5ad"
// <auto-generated/>
#pragma warning disable 1591
[assembly: global::Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItemAttribute(typeof(AspNetCore.Views_Home_Student), @"mvc.1.0.view", @"/Views/Home/Student.cshtml")]
namespace AspNetCore
{
    #line hidden
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.AspNetCore.Mvc;
    using Microsoft.AspNetCore.Mvc.Rendering;
    using Microsoft.AspNetCore.Mvc.ViewFeatures;
#nullable restore
#line 1 "C:\Users\Abdusattar\RiderProjects\UNI\UNI\Views\_ViewImports.cshtml"
using UNI;

#line default
#line hidden
#nullable disable
#nullable restore
#line 2 "C:\Users\Abdusattar\RiderProjects\UNI\UNI\Views\_ViewImports.cshtml"
using UNI.Models;

#line default
#line hidden
#nullable disable
#nullable restore
#line 1 "C:\Users\Abdusattar\RiderProjects\UNI\UNI\Views\Home\Student.cshtml"
using UNI.Data;

#line default
#line hidden
#nullable disable
#nullable restore
#line 2 "C:\Users\Abdusattar\RiderProjects\UNI\UNI\Views\Home\Student.cshtml"
using Microsoft.EntityFrameworkCore;

#line default
#line hidden
#nullable disable
#nullable restore
#line 3 "C:\Users\Abdusattar\RiderProjects\UNI\UNI\Views\Home\Student.cshtml"
using UNI.Data;

#line default
#line hidden
#nullable disable
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"d232b284a060bab74069afc4cc96efa53d05a5ad", @"/Views/Home/Student.cshtml")]
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"51238f28518c0381550dc9ddf08cbb266b976df8", @"/Views/_ViewImports.cshtml")]
    public class Views_Home_Student : global::Microsoft.AspNetCore.Mvc.Razor.RazorPage<dynamic>
    {
        #pragma warning disable 1998
        public async override global::System.Threading.Tasks.Task ExecuteAsync()
        {
            WriteLiteral("﻿");
#nullable restore
#line 4 "C:\Users\Abdusattar\RiderProjects\UNI\UNI\Views\Home\Student.cshtml"
  
    long uid = long.Parse(Context.User.Identity.Name!);
    ViewData["Title"] = "Main page";
    var subjects = new List<Subject>();
    var db = (ApplicationDbContext) ViewData["db"];
    var conn = db.Database.GetDbConnection();
    await conn.OpenAsync();
    var cmd = conn.CreateCommand();
    cmd.CommandText = $"SELECT * FROM student_subjects({uid})";
    var reader = await cmd.ExecuteReaderAsync();
    while (await reader.ReadAsync())
    {
        subjects.Add(new Subject((long) reader[0], (string) reader[1], (int) reader[2]));
    }
    await reader.DisposeAsync();

#line default
#line hidden
#nullable disable
            WriteLiteral("<div>\r\n    <span style=\"font-family: Verdana, sans-serif; font-size: 16px;\">Your id: ");
#nullable restore
#line 21 "C:\Users\Abdusattar\RiderProjects\UNI\UNI\Views\Home\Student.cshtml"
                                                                         Write(uid);

#line default
#line hidden
#nullable disable
            WriteLiteral("</span>\r\n</div>\r\n<div>\r\n    <ul>\r\n");
#nullable restore
#line 25 "C:\Users\Abdusattar\RiderProjects\UNI\UNI\Views\Home\Student.cshtml"
          
            foreach (var subject in subjects)
            {
                cmd.CommandText = $"SELECT * FROM student_current_grade_of_subject({uid}, {subject.subject_id})";
                var predict = await cmd.ExecuteScalarAsync();
                var grade = (double) (predict is DBNull ? 0.0 : predict);
                cmd.CommandText = $"SELECT * FROM forecast_for_student_of_subject({uid}, {subject.subject_id})";
                predict = (await cmd.ExecuteScalarAsync())!;
                var forecast = (double) (predict is DBNull ? 0.0 : predict);

#line default
#line hidden
#nullable disable
            WriteLiteral("                <li>");
#nullable restore
#line 34 "C:\Users\Abdusattar\RiderProjects\UNI\UNI\Views\Home\Student.cshtml"
               Write(subject.subject_name);

#line default
#line hidden
#nullable disable
            WriteLiteral(", current grade ");
#nullable restore
#line 34 "C:\Users\Abdusattar\RiderProjects\UNI\UNI\Views\Home\Student.cshtml"
                                                    Write(grade);

#line default
#line hidden
#nullable disable
            WriteLiteral(", forecast grade ");
#nullable restore
#line 34 "C:\Users\Abdusattar\RiderProjects\UNI\UNI\Views\Home\Student.cshtml"
                                                                            Write(grade + forecast);

#line default
#line hidden
#nullable disable
            WriteLiteral("</li>\r\n");
#nullable restore
#line 35 "C:\Users\Abdusattar\RiderProjects\UNI\UNI\Views\Home\Student.cshtml"
            }
        

#line default
#line hidden
#nullable disable
            WriteLiteral("    </ul>\r\n");
#nullable restore
#line 38 "C:\Users\Abdusattar\RiderProjects\UNI\UNI\Views\Home\Student.cshtml"
      
        cmd.CommandText = "SELECT * FROM events";
        List<Event> events = new List<Event>();
        reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            events.Add(new Event {event_id = (long) reader[0], event_icon = (string) reader[1], event_date = (DateTime) reader[2], title = (string) reader[3], description = (string) reader[4]});
        }
        await reader.DisposeAsync();
        foreach (var e in events)
        {

#line default
#line hidden
#nullable disable
            WriteLiteral("            <div class=\"border-top\">\r\n                <span class=\"h3 d-block\">");
#nullable restore
#line 50 "C:\Users\Abdusattar\RiderProjects\UNI\UNI\Views\Home\Student.cshtml"
                                    Write(e.title);

#line default
#line hidden
#nullable disable
            WriteLiteral(": ");
#nullable restore
#line 50 "C:\Users\Abdusattar\RiderProjects\UNI\UNI\Views\Home\Student.cshtml"
                                              Write(e.event_date.ToString("yyyy-MM-dd"));

#line default
#line hidden
#nullable disable
            WriteLiteral("</span>\r\n                <img");
            BeginWriteAttribute("src", " src=\"", 2177, "\"", 2214, 1);
#nullable restore
#line 51 "C:\Users\Abdusattar\RiderProjects\UNI\UNI\Views\Home\Student.cshtml"
WriteAttributeValue("", 2183, Url.Content("icons/event.png"), 2183, 31, false);

#line default
#line hidden
#nullable disable
            EndWriteAttribute();
            WriteLiteral(" />\r\n                <span class=\"font-weight-bold\">\r\n                    ");
#nullable restore
#line 53 "C:\Users\Abdusattar\RiderProjects\UNI\UNI\Views\Home\Student.cshtml"
               Write(e.description);

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n                </span>\r\n            </div>\r\n");
#nullable restore
#line 56 "C:\Users\Abdusattar\RiderProjects\UNI\UNI\Views\Home\Student.cshtml"
        }
    

#line default
#line hidden
#nullable disable
            WriteLiteral("</div>\r\n");
        }
        #pragma warning restore 1998
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.ViewFeatures.IModelExpressionProvider ModelExpressionProvider { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.IUrlHelper Url { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.IViewComponentHelper Component { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.Rendering.IJsonHelper Json { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<dynamic> Html { get; private set; }
    }
}
#pragma warning restore 1591
