import { formatNum, roundNum } from "./formatter.utils";
import { describe, expect, test } from "vitest";

describe("formatter.utils", () => {
  test("Number should be formatted in human readable format", () => {
    expect(formatNum(0)).toBe("0");
    expect(formatNum(1000)).toBe("1K");
    expect(formatNum(1100)).toBe("1.1K");
    expect(formatNum(1580)).toBe("1.6K");
    expect(formatNum(100_000)).toBe("100K");
    expect(formatNum(10_00_0000)).toBe("10M");
  });

  test("Handle invalid params", () => {
    // @ts-expect-error    
    expect(formatNum(undefined)).toBe("NaN");
    // @ts-expect-error
    expect(formatNum(null)).toBe("0");
    // @ts-expect-error
    expect(formatNum("Test"!)).toBe("NaN");
  });
});

describe("formatter.formatNum", () => {
  test("Number should be rounded to the specified number of digits", () => {
    expect(roundNum(0)).toBe(0);
    expect(roundNum(0.1)).toBe(0);
    expect(roundNum(0.9)).toBe(1);
    expect(roundNum(1.1)).toBe(1);
    expect(roundNum(1.9)).toBe(2);
    expect(roundNum(10.1)).toBe(10);
    expect(roundNum(10.924, 2)).toBe(10.92);
    expect(roundNum(10.964, 2)).toBe(10.96);
    expect(roundNum(10.960, 1)).toBe(11);
  });
});
