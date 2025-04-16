using System;
using System.Globalization;

public static class MoneyConverter
{
    public static ulong ConvertToKurus(string moneyString)
    {
        if (string.IsNullOrWhiteSpace(moneyString))
            throw new ArgumentException("Input cannot be null or empty.");

        // Always use '.' as decimal separator regardless of system culture
        if (!decimal.TryParse(moneyString, NumberStyles.Number, CultureInfo.InvariantCulture, out decimal amount))
            throw new FormatException("Invalid money format.");

        // Truncate to 2 decimal places (no rounding)
        decimal truncated = Math.Floor(amount * 100) / 100;

        // Convert to kuruş and ensure positive value
        decimal kuruşValue = truncated * 100;

        if (kuruşValue < 0 || kuruşValue > ulong.MaxValue)
            throw new OverflowException("Value is out of range for ulong.");

        return (ulong)kuruşValue;
    }
}
