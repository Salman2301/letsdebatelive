import pkg from 'isomorphic-dompurify';
const {sanitize} = pkg;

export function convetToHtml(text: string) {
  let formattedText = text
  .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>') // Bold: **text**
  .replace(/\*(.*?)\*/g, '<em>$1</em>') // Italic: *text*
  .replace(/_(.*?)_/g, '<u>$1</u>') // Underline: _text_
  .replace(/~~(.*?)~~/g, '<del>$1</del>') // Strikethrough: ~~text~~
  .replace(/@(\w+)/g, '<a href="/user/$1">@$1</a>') // User Mention: @username
  .replace(/(https:\/\/[^\s]+)/g, '<a href="$1" target="_blank">$1</a>'); // URL: https://

  return sanitize(formattedText);
}
