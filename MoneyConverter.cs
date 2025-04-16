using System;
using System.Globalization;
public static class MoneyConverter
{
    public static ulong ConvertToKurus(string moneyString)
    {
        if (string.IsNullOrWhiteSpace(moneyString))
            throw new ArgumentException("Input cannot be null or empty.");

        // Split to check the fraction part manually
        var parts = moneyString.Split('.');
        if (parts.Length > 2)
            throw new FormatException("Invalid money format: too many decimal points.");

        if (parts.Length == 2 && parts[1].Length > 2)
            throw new FormatException("Fractional part cannot have more than 2 digits.");

        // Parse using invariant culture
        if (!decimal.TryParse(moneyString, NumberStyles.Number, CultureInfo.InvariantCulture, out decimal amount))
            throw new FormatException("Invalid money format.");

        // Multiply to get kuruş
        decimal kuruşValue = amount * 100;

        if (kuruşValue < 0 || kuruşValue > ulong.MaxValue)
            throw new OverflowException("Value is out of range for ulong.");

        return (ulong)kuruşValue;
    }
}
