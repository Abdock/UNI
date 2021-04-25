#pragma checksum "C:\Users\Тимур\RiderProjects\UNI3\UNI\Views\Home\Teacher.cshtml" "{ff1816ec-aa5e-4d10-87f7-6f4963833460}" "64df21923806c90e904bc85a0288243a47b2d7d0"
// <auto-generated/>
#pragma warning disable 1591
[assembly: global::Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItemAttribute(typeof(AspNetCore.Views_Home_Teacher), @"mvc.1.0.view", @"/Views/Home/Teacher.cshtml")]
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
#line 1 "C:\Users\Тимур\RiderProjects\UNI3\UNI\Views\_ViewImports.cshtml"
using UNI;

#line default
#line hidden
#nullable disable
#nullable restore
#line 2 "C:\Users\Тимур\RiderProjects\UNI3\UNI\Views\_ViewImports.cshtml"
using UNI.Models;

#line default
#line hidden
#nullable disable
#nullable restore
#line 1 "C:\Users\Тимур\RiderProjects\UNI3\UNI\Views\Home\Teacher.cshtml"
using UNI.Data;

#line default
#line hidden
#nullable disable
#nullable restore
#line 2 "C:\Users\Тимур\RiderProjects\UNI3\UNI\Views\Home\Teacher.cshtml"
using Microsoft.EntityFrameworkCore;

#line default
#line hidden
#nullable disable
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"64df21923806c90e904bc85a0288243a47b2d7d0", @"/Views/Home/Teacher.cshtml")]
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"51238f28518c0381550dc9ddf08cbb266b976df8", @"/Views/_ViewImports.cshtml")]
    public class Views_Home_Teacher : global::Microsoft.AspNetCore.Mvc.Razor.RazorPage<UNI.ViewModels.LoginModel>
    {
        #pragma warning disable 1998
        public async override global::System.Threading.Tasks.Task ExecuteAsync()
        {
#nullable restore
#line 4 "C:\Users\Тимур\RiderProjects\UNI3\UNI\Views\Home\Teacher.cshtml"
  
    ViewData["Title"] = "Teacher page";
    var groups = new List<Group>();
    var db = (ApplicationDbContext) ViewData["db"];
    var conn = db.Database.GetDbConnection();
    await conn.OpenAsync();
    var cmd = conn.CreateCommand();
    cmd.CommandText = $"SELECT * FROM get_teachers_group({Model.Login})";
    var reader = await cmd.ExecuteReaderAsync();
    while (await reader.ReadAsync())
    {
        groups.Add(new Group {group_id = (long) reader[0], group_name = (string) reader[1], curator_id = (long) reader[2]});
    }
    await reader.DisposeAsync();

#line default
#line hidden
#nullable disable
            WriteLiteral("<ul>\r\n");
#nullable restore
#line 20 "C:\Users\Тимур\RiderProjects\UNI3\UNI\Views\Home\Teacher.cshtml"
      
        foreach (var group in groups)
        {
            
                

#line default
#line hidden
#nullable disable
#nullable restore
#line 24 "C:\Users\Тимур\RiderProjects\UNI3\UNI\Views\Home\Teacher.cshtml"
           Write(group.group_name);

#line default
#line hidden
#nullable disable
            WriteLiteral("                <ul>\r\n");
#nullable restore
#line 26 "C:\Users\Тимур\RiderProjects\UNI3\UNI\Views\Home\Teacher.cshtml"
                      
                        cmd.CommandText = $"SELECT * FROM group_subjects({group.group_id})";
                        List<Subject> subjects = new List<Subject>();
                        reader = await cmd.ExecuteReaderAsync();
                        while (await reader.ReadAsync())
                        {
                            subjects.Add(new Subject {subject_id = (long) reader[0], subject_name = (string) reader[1], credits = (int) reader[2]});
                        }
                        await reader.DisposeAsync();
                        foreach (var subject in subjects)
                        {
                            cmd.CommandText = $"SELECT * FROM ratio_of_student_in_group({group.group_id}, {subject.subject_id}, 90, 100)";
                            var exc = (double) await cmd.ExecuteScalarAsync();
                            cmd.CommandText = $"SELECT * FROM ratio_of_student_in_group({group.group_id}, {subject.subject_id}, 70, 89)";
                            var good = (double) await cmd.ExecuteScalarAsync();
                            cmd.CommandText = $"SELECT * FROM ratio_of_student_in_group({group.group_id}, {subject.subject_id}, 50, 69)";
                            var middle = (double) await cmd.ExecuteScalarAsync();
                            cmd.CommandText = $"SELECT * FROM ratio_of_student_in_group({group.group_id}, {subject.subject_id}, 0, 50)";
                            var low = (double) await cmd.ExecuteScalarAsync();

#line default
#line hidden
#nullable disable
            WriteLiteral("                            <section class=\"ac-container\">\r\n                                <div>\r\n                                    <input id=\"ac-1\" name=\"accordion-1\" type=\"checkbox\" checked />\r\n                                    <label for=\"ac-1\">");
#nullable restore
#line 48 "C:\Users\Тимур\RiderProjects\UNI3\UNI\Views\Home\Teacher.cshtml"
                                                 Write(subject.subject_name);

#line default
#line hidden
#nullable disable
            WriteLiteral(":</label>\r\n                                    <article>\r\n                                        <p>Excellent: ");
#nullable restore
#line 50 "C:\Users\Тимур\RiderProjects\UNI3\UNI\Views\Home\Teacher.cshtml"
                                                 Write(exc);

#line default
#line hidden
#nullable disable
            WriteLiteral(" </p>\r\n                                    </article>\r\n                                      <article>\r\n                                                                         <p>Good: ");
#nullable restore
#line 53 "C:\Users\Тимур\RiderProjects\UNI3\UNI\Views\Home\Teacher.cshtml"
                                                                             Write(good);

#line default
#line hidden
#nullable disable
            WriteLiteral("</p>\r\n                                    </article>   \r\n                                    <article>\r\n                                        <p>Middle: ");
#nullable restore
#line 56 "C:\Users\Тимур\RiderProjects\UNI3\UNI\Views\Home\Teacher.cshtml"
                                              Write(middle);

#line default
#line hidden
#nullable disable
            WriteLiteral("</p>\r\n                                    </article>\r\n                                         <article>\r\n                                                                            <p>Low: ");
#nullable restore
#line 59 "C:\Users\Тимур\RiderProjects\UNI3\UNI\Views\Home\Teacher.cshtml"
                                                                               Write(low);

#line default
#line hidden
#nullable disable
            WriteLiteral("</p>\r\n                                                                        </article>\r\n                                </div>\r\n                 \r\n                            </section>\r\n");
#nullable restore
#line 64 "C:\Users\Тимур\RiderProjects\UNI3\UNI\Views\Home\Teacher.cshtml"
        
                        }
                    

#line default
#line hidden
#nullable disable
            WriteLiteral("                </ul>\r\n");
#nullable restore
#line 68 "C:\Users\Тимур\RiderProjects\UNI3\UNI\Views\Home\Teacher.cshtml"
            
        }
    

#line default
#line hidden
#nullable disable
            WriteLiteral("</ul>\r\n");
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
        public global::Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<UNI.ViewModels.LoginModel> Html { get; private set; }
    }
}
#pragma warning restore 1591
