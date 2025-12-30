using System;
using System.ComponentModel.DataAnnotations;

namespace MyWebApi.Models
{
    public class WeatherForecast
    {
        [Key]
        public int Id { get; set; }
        public DateTime Date { get; set; }
        public int TemperatureC { get; set; }
        public string? Summary { get; set; }
    }
}
