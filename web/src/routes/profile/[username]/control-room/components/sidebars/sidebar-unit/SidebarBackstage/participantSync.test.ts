import { expect, test, beforeEach, afterEach, vi, it } from 'vitest'
import { onParticpantChange, registeredCallBacks, triggerParticipantChange } from './participantSync';

beforeEach(() => {
  for (const key in registeredCallBacks) {
    delete registeredCallBacks[key];
  }
});

afterEach(() => {
  for (const key in registeredCallBacks) {
    delete registeredCallBacks[key];
  }
});


test('onParticpantChange registers a callback', () => {
  const id = '1234';
  
  const cb = vi.fn();

  const subscription = onParticpantChange(id, cb);

  expect(registeredCallBacks[id]).toBeDefined();
  expect(Object.keys(registeredCallBacks[id])).toHaveLength(1);
  expect(registeredCallBacks[id][subscription.participantSubId]).toBe(cb);

  // Clean up
  subscription.destroy();
});

test('onParticpantChange destroy method removes the callback', () => {
  const id = '1234';

  const cb = vi.fn();
  const subscription = onParticpantChange(id, cb);

  expect(registeredCallBacks[id][subscription.participantSubId]).toBe(cb);

  // Call destroy method
  subscription.destroy();

  expect(registeredCallBacks[id][subscription.participantSubId]).toBeUndefined();
  expect(Object.keys(registeredCallBacks[id])).toHaveLength(0);
});

test('triggerParticipantChange invokes all callbacks', () => {
  const id = '1234';
  const participant: any = { id: '5678' };

  const callback1 = vi.fn();
  const callback2 = vi.fn();

  const subscription1 = onParticpantChange(id, callback1);
  const subscription2 = onParticpantChange(id, callback2);

  triggerParticipantChange(id, participant);

  expect(callback1).toHaveBeenCalledWith(participant);
  expect(callback2).toHaveBeenCalledWith(participant);
  
  triggerParticipantChange(id, participant);
  expect(callback1).toHaveBeenCalledTimes(2)

  subscription1.destroy();
  subscription2.destroy();

  expect(Object.values(Object.values(registeredCallBacks)[0]).length).toBe(0)
});

test('triggerParticipantChange remove all callbacks on done', () => {
  const id = '1234';
  const subscription1 = onParticpantChange(id, vi.fn());
  const subscription2 = onParticpantChange(id, vi.fn());

  subscription1.destroy();
  subscription2.destroy();

  expect(Object.values(Object.values(registeredCallBacks)[0]).length).toBe(0)
});
