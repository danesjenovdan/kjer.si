<template src='./Chat.html'>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped src="./Chat.scss" lang="scss">
</style>

<script>

  import Discover from "../Discover/Discover";
  import Events from "../Events/Events";
  import * as SocketService from '../../services/socket.service';
  import * as UserService from '../../services/user.service';
  import * as app from 'tns-core-modules/application';
  import * as platform from 'tns-core-modules/platform';
  import * as Phx from "../../assets/js/phoenix";
  import * as ApiService from "../../services/api.service";
  import {ObservableArray} from 'tns-core-modules/data/observable-array';
  import * as UUID from 'nativescript-uuid';
  import * as utils from "tns-core-modules/utils/utils";
  import {isIOS, isAndroid} from "tns-core-modules/platform";
  import * as frame from "tns-core-modules/ui/frame";
  import NewEvent from "../NewEvent/NewEvent";
  import Toggle from "../shared/Toggle/Toggle";
  import * as firebase from "nativescript-plugin-firebase";
  import * as dialogs from "tns-core-modules/ui/dialogs";

  export default {
    components: {
      Toggle
    },
    props: ['roomId', 'roomName', 'room'],
    data() {
      return {
        showMenu: false,
        channel: null,
        userId: UserService.default.user.id,
        messageText: '',
        messages: new ObservableArray([]),
      };
    },
    computed: {
      message() {
        return "Blank {N}-Vue app";
      }
    },
    async mounted() {

      this.enabledNotifications = !UserService.default.isRoomMuted(this.roomId);
      console.log('Notifications are enabled: ', this.enabledNotifications);

      this._onMessage = this.onMessage.bind(this);

      SocketService.default.messageEmitter.on('message', this._onMessage);

      this.$refs.pageRef.nativeView.actionBarHidden = true;
      if (platform.isAndroid) {
        const window = app.android.startActivity.getWindow();
        window.setSoftInputMode(android.view.WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
      }
      await this.getRoomMessages();
      this.scrollTo(false);
      this.setupChannel();
      this.messages.on(ObservableArray.changeEvent, this.onMessagesUpdate.bind(this));
      this.setupListView();

    },
    destroyed() {
      clearInterval(this.scrollInterval);
      this.scrollInterval = null
      SocketService.default.messageEmitter.off('message', this._onMessage);
    },
    methods: {

      onNotificationCheckedChange() {
        this.toggleNotifications();
      },

      onNotificationToggleTap() {
        this.enabledNotifications = !this.enabledNotifications;
        this.dropDownButtonTapped = true;
      },

      onSwitchTap() {

      },

      toggleNotifications() {

        try {
          if (!this.enabledNotifications) {
            UserService.default.addMutedRoom(this.roomId);
          } else {
            UserService.default.removeFromMutedRooms(this.roomId);
          }
        } catch (e) {
          console.log('Room mute error: ', e);
        }

        if (UserService.default.isRoomMuted(this.roomId)) {
          firebase.unsubscribeFromTopic(this.roomId).then(() => console.log('Unsubscribed from topic'));
        } else {
          firebase.subscribeToTopic(this.roomId).then(() => console.log('Subscribed to topic'));
        }

      },

      async onLeaveRoomTap($event) {

        const result = await dialogs.confirm('Ste prepričani da želite zapustiti sobo?');

        if (!result) {
          return;
        }

        this.$navigateBack();
        try {
          await ApiService.default.leaveRoom(this.roomId);
          this.room.memberCount = this.room.memberCount - 1;
          this.room.amMember = false;
          console.log(this.room.memberCount);
        } catch (e) {

        }
        this.dropDownButtonTapped = true;
      },

      setupChannel() {
        console.log('roomId: ', this.roomId);
        SocketService.default.joinRoom(this.roomId);
      },

      async getRoomMessages(beginning = false) {
        this.loading = true;
        const messages = await ApiService.default.getRoomMessages(this.roomId, beginning ? this.messages.getItem(0).createdAt : null);
        if (beginning) {
          messages.reverse();
        }
        messages.forEach((m) => {
          if (m.author && m.author._id === UserService.default.user._id) {
            m.type = 'MY_TEXT';
          }
          if (beginning) {
            this.messages.unshift(m);
          } else {
            this.messages.push(m);
          }
        });
        setTimeout(() => {
          this.loading = false;
        }, 10);

        return messages.length;
      },

      setupListView() {
        if (!this.scrollInterval) {
          this.scrollInterval = setInterval(() => {
            const canScrollUp = this.canScrollUp();
            if (!canScrollUp) {
              this.topReached();
              this.atTop = true;
            } else {
              this.atTop = false;
            }
          }, 100);
        }
      },

      async topReached() {
        if (!this.canScroll() || this.atTop) {
          return;
        }
        console.log('TOP REACHED: ', this.topReachedCount++);
        if (!this.loading) {
          try {
            const index = await this.getRoomMessages(true);
            if (index) {
              this.scrollTo(false, index);
            }
          } catch (e) {
            console.log('Error: ', e);
          }
        }
      },

      onMessage(message) {
        console.log('Message');
        if (message.author._id === UserService.default.user._id) {
          message.type = 'MY_TEXT';
        }
        this.messages.push(message);
        this.scrollTo(true);
      },

      onTextViewTap() {
        if (!this.messages || !this.messages.length) {
          return;
        }
        if (this.isBottom()) {
          setTimeout(() => {
            this.scrollTo(false);
          }, 140);
        }
      },

      canScroll() {
        const last = this.$refs.chatListView.nativeView.android.getLastVisiblePosition();
        if (last == this.$refs.chatListView.nativeView.android.getCount() - 1 && this.$refs.chatListView.nativeView.android.getChildAt(last).getBottom() <= this.$refs.chatListView.nativeView.android.getHeight()) {
          return false;
        } else {
          return true;
        }
      },

      onMessagesUpdate() {

        // setTimeout(() => {
        //   this.scrollTo();
        // });

      },

      scrollTo(smooth = true, index) {
        if (platform.isAndroid) {

          let offset = this.messages.length - 1;
          if (index) {
            offset = index;
          }

          if (this.$refs.chatListView.nativeView.android) {
            if (!smooth) {
              this.$refs.chatListView.nativeView.android.setSelection(offset);
            } else {
              this.$refs.chatListView.nativeView.android.smoothScrollToPosition(offset);
            }
          } else {
            this.$refs.chatListView.nativeView.scrollToIndex(offset);
          }
        }
      },

      isBottom() {

        if (isAndroid) {
          return this.$refs.chatListView.nativeView.android.getLastVisiblePosition() == this.$refs.chatListView.nativeView.android.getAdapter().getCount() - 1 &&
            this.$refs.chatListView.nativeView.android.getChildAt(this.$refs.chatListView.nativeView.android.getChildCount() - 1).getBottom() <= this.$refs.chatListView.nativeView.android.getHeight();
        } else {
          return false;
        }

      },

      canScrollUp() {

        if (isAndroid) {
          if (android.os.Build.VERSION.SDK_INT < 14) {
            if (this.$refs.chatListView.nativeView.android instanceof AbsListView) {
              const absListView = this.$refs.chatListView.nativeView.android;
              return absListView.getChildCount() > 0
                && (absListView.getFirstVisiblePosition() > 0 || absListView
                  .getChildAt(0).getTop() < absListView.getPaddingTop());
            } else {
              return this.$refs.chatListView.nativeView.android.getScrollY() > 0;
            }
          } else {
            return androidx.core.view.ViewCompat.canScrollVertically(this.$refs.chatListView.nativeView.android, -1);
          }
        }
      },

      onNewEventTap() {

        this.$navigateTo(NewEvent, {
          transition: {
            name: 'slideLeft',
            duration: 300,
            curve: 'easeInOut'
            // curve: cubicBezier(0.175, 0.885, 0.32, 1.275)
          }
        });

      },

      onSendTap() {

        if (!this.messageText) {
          return;
        }

        console.log('Send message');
        SocketService.default.sendMessage(this.roomId, this.messageText);
        this.messageText = '';
        // this.dismissSoftKeyboard();

      },

      dismissSoftKeyboard() {

        if (isIOS) {
          frame.topmost().nativeView.endEditing(true);
        }
        if (isAndroid) {
          utils.ad.dismissSoftInput();
        }

      },

      goToDiscoverPage() {
        console.log('TAP: go to discover page');
        this.$navigateTo(Discover);
      },

      onBackTap() {
        console.log('TAP: go back');
        this.$navigateBack();
      },

      onContainerTap() {
        setTimeout(() => {
          if (!this.dropDownButtonTapped) {
            this.showMenu = false;
          }
          this.dropDownButtonTapped = false;
        });
      },

      onMenuTap() {
        console.log('TAP: open menu');
        setTimeout(() => {
          this.showMenu = true;
        }, 10);
      },

      onEventsTap() {
        console.log('TAP: events');
        this.$navigateTo(Events, {
          transition: {
            name: 'slideLeft',
            duration: 300,
            curve: 'easeInOut'
          }
        });
      }

    }
  };

</script>
