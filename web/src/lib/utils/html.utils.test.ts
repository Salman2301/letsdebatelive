import { describe, expect, it } from 'vitest';
import { convetToHtml } from './html.utils';

describe('html.utils', () => {
  it('should convert markdown to html', () => {
    const text = '**bold** *italic* _underline_ ~~strikethrough~~ https://github.com';
    const expected = '<strong>bold</strong> <em>italic</em> <u>underline</u> <del>strikethrough</del> <a href="https://github.com">https://github.com</a>';
    expect(convetToHtml(text)).toBe(expected);
  });
});

