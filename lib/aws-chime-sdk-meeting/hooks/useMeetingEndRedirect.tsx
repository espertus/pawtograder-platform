// Copyright 2020-2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0

import { useEffect } from 'react';
import { useRouter } from 'next/navigation';

import {
  MeetingStatus,
  useNotificationDispatch,
  Severity,
  ActionType,
  useMeetingStatus,
  useLogger,
} from 'amazon-chime-sdk-component-library-react';
import routes from '../constants/routes';

const useMeetingEndRedirect = () => {
  const logger = useLogger();
  const router = useRouter()
  const dispatch = useNotificationDispatch();
  const meetingStatus = useMeetingStatus();

  useEffect(() => {
    if (meetingStatus === MeetingStatus.Ended) {
      logger.info('[useMeetingEndRedirect] Meeting ended');
      dispatch({
        type: ActionType.ADD,
        payload: {
          severity: Severity.INFO,
          message: 'The meeting was ended by another attendee',
          autoClose: true,
          replaceAll: true,
        },
      });
      router.push(routes.HOME);
    }
  }, [meetingStatus]);
};

export default useMeetingEndRedirect;
